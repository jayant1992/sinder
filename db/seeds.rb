# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# 5.times do |i|
#   Release.create name: "Release ##{i+1}"
# end

require 'musicbrainz'
require 'rest-client'
require 'uri'
require 'google/api_client'
require 'trollop'

YT_DEVELOPER_KEY = 'AIzaSyCV-QNALLK-RdVuhk9a-gSCZVU3qCRvxbM'
YOUTUBE_API_SERVICE_NAME = 'youtube'
YOUTUBE_API_VERSION = 'v3'

def get_service
  client = Google::APIClient.new(
    :key => YT_DEVELOPER_KEY,
    :authorization => nil,
    :application_name => 'Sinder',
    :application_version => '1.0.0'
  )
  youtube = client.discovered_api(YOUTUBE_API_SERVICE_NAME, YOUTUBE_API_VERSION)

  return client, youtube
end

def add_yt_id(row)
  opts = Trollop::options do
    opt :q, 'Search term', :type => String, :default => "#{row[0]} #{row[1]}"
    opt :max_results, 'Max Results', :type => :int, :default => 1
  end

  client, youtube = get_service

  begin
    # Call the search.list method to retrieve results matching the specified
    # query term.
    search_response = client.execute!(
      :api_method => youtube.search.list,
      :parameters => {
        :part => 'snippet',
        :q => opts[:q],
        :maxResults => opts[:max_results]
      }
    )

    vid = nil
    items = search_response.data.items
    unless items.length==0
      result = search_response.data.items.first.id
      if result.kind=="youtube#video"
        vid =  result.videoId
      end
    end
    return vid

  rescue Google::APIClient::TransmissionError => e
    puts e.result.body
  end
end


def getmbtags(row)

  tags = []
  recording = (MusicBrainz::Recording.search(row[0], row[1]))[0]

  unless recording.blank?
    trackmbid = recording[:id]

    begin
      enc_uri = URI.escape("http://musicbrainz.org/ws/2/recording?query=#{row[0]} AND arid:#{row[2]}&fmt=json")      
      response = RestClient.get enc_uri
    rescue => e
      e.response
    else
      resp_hash = JSON.parse response
      resp_hash["recordings"].each do |resp|
        unless resp["tags"].blank?
          resp["tags"].each {|tag| tags << tag["name"] }
        end
      end
    end
    tags.uniq!
    # MB rate limits
    sleep(1.0)
    return tags
  end
  return []
end

begin

  MusicBrainz.configure do |c|
    # Application identity (required)
    c.app_name = "Sinder"
    c.app_version = "1.0"
    c.contact = "saurabh.kumar@housing.com"

    # Cache config (optional)
    c.cache_path = "/tmp/musicbrainz-cache"
    c.perform_caching = true

    # Querying config (optional)
    c.tries_limit = 2
  end

  db = SQLite3::Database.new "datasets/track_metadata.db"
  fields = ["title", "artist_name", "artist_mbid", "release", "year"]

  count = db.get_first_value( "SELECT COUNT(*) FROM songs WHERE artist_familiarity > 0.85 and artist_mbid!=''" )
  
  stm = db.prepare "SELECT " + fields.join(", ") + " FROM songs WHERE artist_familiarity > 0.85 and artist_mbid!=''" 
  rs = stm.execute 
  
  artists = {}
  releases = {}
  
  rs.each_with_index do |row, index|
    if artists.has_key? row[1]
      artist = artists[row[1]]
    else
      artist = Artist.find_or_create_by name: row[1], mb_id: row[2]
      artists[row[1]] = artist
    end

    if releases.has_key? row[3]
      release = releases[row[3]]
    else
      release = Release.find_or_create_by name: row[3]
      releases[row[3]] = release
    end

    unless artist.songs.find_by title: row[0], release_id: release.id, year: row[4]
      tags = getmbtags row
      song = artist.songs.create title: row[0], release_id: release.id, year: row[4]
      tags.each { |tag| song.tag << Tag.find_or_create_by(:name => tag) } unless tags.nil?
    else
      song = artist.songs.find_by title: row[0], release_id: release.id, year: row[4]
    end

    if song.youtube_id.nil?
      yid = add_yt_id row
      song.update(youtube_id: yid) unless yid.nil?
      song.save!
    end

    puts "Processing #{index} of #{count}."
  end

rescue SQLite3::Exception => e 
  puts "Exception occurred"
  puts e
  
ensure
  stm.close if stm
  db.close if db
end
