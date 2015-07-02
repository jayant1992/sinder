module Reco

    def like_recommendations
        my_songs = liked_songs.only(:id, :liker_ids)
        friends = User.all
        reco = Hash.new(0)
        friends.each do |friend|
            in_common = (friend.liked_song_ids & self.liked_song_ids)
            w = in_common.size.to_f / friend.liked_song_ids.size
            ( friend.liked_song_ids - in_common).each do |song_id|
                reco[song_id] += w
            end
        end
        reco
    end

    def dislike_recommendations
        my_songs = disliked_songs.only(:id, :disliker_ids)
        friends = User.all
        reco = Hash.new(0)
        friends.each do |friend|
            in_common = (friend.disliked_song_ids & self.disliked_song_ids)
            w = in_common.size.to_f / friend.disliked_song_ids.size
            ( friend.disliked_song_ids - in_common).each do |song_id|
                reco[song_id] += w
            end
        end
        reco
    end

    def neutral_recommendations
        my_songs = neutral_songs.only(:id, :neutral_ids)
        friends = User.all
        reco = Hash.new(0)
        friends.each do |friend|
            in_common = (friend.neutral_song_ids & self.neutral_song_ids)
            w = in_common.size.to_f / friend.neutral_song_ids.size
            ( friend.neutral_song_ids - in_common).each do |song_id|
                reco[song_id] += w
            end
        end
        reco
    end

    def genre_recommendations
    end

    def artist_recommendations
    end

    def recommendations
        like_recommendations.update(dislike_recommendations) { |k, v1, v2| v1 - 2*v2 }.update(neutral_recommendations) { |k, v1, v2| v1 + v2 }
    end

end
