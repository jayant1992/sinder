class CreateJoinTableSongsUsersDislikes < ActiveRecord::Migration
    def change
        create_table :songs_users_dislikes do |t|
            t.references :song, :null => false
            t.references :user, :null => false
            # t.index [:song_id, :user_id]
            # t.index [:user_id, :song_id]
        end
    end
end
