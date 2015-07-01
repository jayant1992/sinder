class ArtistsController < ApplicationController

    def get_all_artists
        all_artists = Artist.all
        all_artists.to_json
    end

    def get_artist_by_id
        artist = Artist.find(params[:id])
        artist.to_json
    end

    def get_artist_by_name
        artist = Artist.find_by(name:params[:name])
        artist.to_json
    end
    
    def get_artist_by_mb_id
        artist = Artist.find_by(mb_id:params[:mb_id])
        artist.to_json
    end

end
