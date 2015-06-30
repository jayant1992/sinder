class RecommendationController < ApplicationController
  def index
  end

  def next_recommendation
      render text: "Next recommendation"
  end

  def previous_recommendation
      render text: "Previous recommendation"
  end
end
