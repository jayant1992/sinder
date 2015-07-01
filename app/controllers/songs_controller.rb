class SongsController < ApplicationController
	def index
	end

    def get_all_songs
        all_songs = Song.all
        all_songs.to_json
    end

    def get_song_by_id
        song = Song.find(id:params[:id])
        song.to_json
    end

    def get_song_by_year
        song = Song.find_by(year:params[:year])
        song.to_json
    end

end
