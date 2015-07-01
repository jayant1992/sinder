module Api
  class SongsController < Api::BaseController

    private

    def songs_params
      params.require(:song).permit(:title)
    end

    def query_params
      # this assumes that an song belongs to an artist and has an :artist_id
      # allowing us to filter by this
      params.permit(:artist_id, :title)
    end
  end
end
