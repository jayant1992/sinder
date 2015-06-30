class ReleasesController < ApplicationController

    def index
    end

    def get_all_releases
        all_releases = Release.all
        all_releases.each do |al|
            render json: al
        end
    end

    def get_release_by_id
        id = params[:id]
        release = Release.find(id)
        release
    end

    def get_release_by_name
        name = params[:name]
        release = Release.find_by(name:name)
        respond_to do |format|
            format.json { render text: release.response }
        end
    end

end
