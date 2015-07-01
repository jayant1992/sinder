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
    end
end
