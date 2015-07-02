require 'reco.rb'

class User < ActiveRecord::Base
    include Reco
    has_and_belongs_to_many :liked_songs, class_name: "Song", join_table: "songs_users_likes"
    def like_song!(song)
        liked_songs << song
    end

    has_and_belongs_to_many :disliked_songs, class_name: "Song", join_table: "songs_users_dislikes"
    def dislike_song!(song)
        disliked_songs << song
    end

    has_and_belongs_to_many :neutral_songs, class_name: "Song", join_table: "songs_users_neutral"
    def neutral_song!(song)
        neutral_songs << song
    end
end
