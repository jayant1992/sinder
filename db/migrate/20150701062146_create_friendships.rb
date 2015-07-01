class CreateFriendships < ActiveRecord::Migration
  def change
    create_table :friendships, id: false do |t|
    	# t.references :user, index: true, foreign_key: true
    	# t.references :friend, references: :users, index: true
    end
    add_column :friendships, :uid, :string, index: true
	add_column :friendships, :friend_uid, :string, index: true
  end
end
