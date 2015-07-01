class Song < ActiveRecord::Base
	include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  belongs_to :artist
  belongs_to :release
  has_and_belongs_to_many :tag
  has_and_belongs_to_many :user
end
