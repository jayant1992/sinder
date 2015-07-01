class ReleasesController < ApplicationController

    def index
    end

    def get_all_releases
        all_releases = Release.all
        all_releases.to_json
    end

    def get_release_by_id
        release = Release.find(id:params[:id])
        release.to_json
    end

    def get_release_by_name
        release = Release.find_by(name:params[:name])
        release.to_json
    end

end
