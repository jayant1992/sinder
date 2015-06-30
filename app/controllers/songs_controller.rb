class SongsController < ApplicationController
	def index
	end

    def get_all_songs
        all_songs = Song.all
        all_songs
    end

    def get_song_by_id
        id = params[:id]
        song = Song.find(id)
        song
    end

    def get_song_by_year
        year = params[:year]
        song = Song.find_by(name:year)
        song
    end

end
