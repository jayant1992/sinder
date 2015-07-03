class Release < ActiveRecord::Base
	include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
	has_many :songs
end
