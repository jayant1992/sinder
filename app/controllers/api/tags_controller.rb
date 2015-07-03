module Api
  class TagsController < Api::BaseController
    
    private

    def tag_params
      params.require(:tag).permit(:name)
    end

    def query_params
      params.permit(:name)
    end
  end
end
