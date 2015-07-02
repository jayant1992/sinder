class Tag < ActiveRecord::Base
	include Searchable
  has_and_belongs_to_many :song
end
