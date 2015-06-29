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

def getmbtags(row)

  tags = []
  recording = (MusicBrainz::Recording.search(row[0], row[1]))[0]

  unless recording.blank?
    trackmbid = recording[:id]

    begin
      response = RestClient.get "http://musicbrainz.org/ws/2/recording?query=#{row[0]} AND arid:#{row[2]}&fmt=json"
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

    song = artist.songs.find_or_create_by title: row[0], release_id: release.id, year: row[4]

    puts "Processing #{index} of #{count}."
    tags = getmbtags row
    tags.each { |tag| song.tag << Tag.find_or_create_by(:name => tag) }
  end

rescue SQLite3::Exception => e 
  puts "Exception occurred"
  puts e
  
ensure
  stm.close if stm
  db.close if db
end
