class Friendship < ActiveRecord::Base
	belongs_to :user, primary_key: 'uid'
	belongs_to :friend, class_name: 'User', foreign_key: 'friend_uid', primary_key: 'uid'
end
