class ArtistsController < ApplicationController

    def get_all_artists
        all_artists = Artist.all
        all_artists
    end

    def get_artist_by_id
        id = params[:id]
        artist = Artist.find(id)
        artist
    end

    def get_artist_by_name
        name = params[:name]
        artist = Artist.find_by(name:name)
        artist
    end
    
    def get_artist_by_mb_id
        mb_id = params[:mb_id]
        artist = Artist.find_by(mb_id:mb_id)
        artist
    end

end
