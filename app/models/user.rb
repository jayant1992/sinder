class User < ActiveRecord::Base
  has_many :friendships, foreign_key: :uid, primary_key: :uid
  has_many :friends, through: :friendships, class_name: "User", primary_key: :uid
  has_and_belongs_to_many :song

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      if auth['info']
         user.name = auth['info']['name'] || ""
         user.email = auth['info']['email'] || ""
      end
      if auth['credentials']
         user.access_token = auth['credentials']['token'] || ""
      end
    end
  end

  def store_fb_friends()
    graph = Koala::Facebook::API.new(self.access_token)
    profile = graph.get_object("me")
    friends = graph.get_connections("me", "friends")
    orig = self
    friends.each do |friend|
      orig.friendships.create(uid: orig.uid, friend_uid: friend['id'])
    end
  end
end
