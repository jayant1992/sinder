class Song < ActiveRecord::Base
    include Searchable
    belongs_to :artist
    belongs_to :release
    has_and_belongs_to_many :tag
    has_and_belongs_to_many :likers, class_name: "User"
    has_and_belongs_to_many :dislikers, class_name: "User"
    has_and_belongs_to_many :neutral, class_name: "User"
end
