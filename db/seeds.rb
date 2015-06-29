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
begin
  db = SQLite3::Database.new "datasets/track_metadata.db"
  fields = ["title", "artist_name", "artist_mbid", "release", "year"]
  
  stm = db.prepare "SELECT " + fields.join(", ") + " FROM songs WHERE artist_familiarity > 0.95" 
  rs = stm.execute 
  
  artists = {}
  releases = {}
  rs.each do |row|
    if artists.has_key? row[1]
      artist = artists[row[1]]
    else
      artist = Artist.create name: row[1], mb_id: row[2]
      artists[row[1]] = artist
    end

    if releases.has_key? row[3]
      release = releases[row[3]]
    else
      release = Release.create name: row[3]
      releases[row[3]] = release
    end

    artist.songs.create title: row[0], release_id: release.id, year: row[4]
  end

rescue SQLite3::Exception => e 
  puts "Exception occurred"
  puts e
  
ensure
  stm.close if stm
  db.close if db
end
