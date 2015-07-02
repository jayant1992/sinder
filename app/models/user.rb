## TODO : Take care of multiple entries
require 'reco.rb'

class User < ActiveRecord::Base
    include Reco
    has_and_belongs_to_many :liked_songs, class_name: "Song", join_table: "songs_users_likes"
    def like!(song)
        liked_songs << song
    end

    has_and_belongs_to_many :disliked_songs, class_name: "Song", join_table: "songs_users_dislikes"
    def dislike!(song)
        disliked_songs << song
    end

    has_and_belongs_to_many :neutral_songs, class_name: "Song", join_table: "songs_users_neutral"
    def neutral!(song)
        neutral_songs << song
    end
end
