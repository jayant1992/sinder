class Song < ActiveRecord::Base
  belongs_to :artist
  belongs_to :release
  has_and_belongs_to_many :tag
end
