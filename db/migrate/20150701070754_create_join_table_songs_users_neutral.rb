class CreateJoinTableSongsUsersNeutral < ActiveRecord::Migration
    def change
        create_table :songs_users_neutral, :id => false do |t|
            t.references :song, :null => false
            t.references :user, :null => false 
        end
    end
end
