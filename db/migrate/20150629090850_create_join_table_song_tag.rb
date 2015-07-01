class CreateJoinTableSongTag < ActiveRecord::Migration
    def change
        create_join_table :songs, :tags do |t|
        end
    end
end
