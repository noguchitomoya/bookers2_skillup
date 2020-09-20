class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  attachment :profile_image, destroy: false
  has_many :books
  has_many :favorites
  has_many :book_comments
  validates :name, presence: true, length: {maximum: 10, minimum: 2}
  validates :introduction, length: {maximum: 50}
  
  # # フォロワー
#  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'followee_id'
#   has_many :followers, source: :follower

  
#   # フォローしている人
#    has_many :relationships, foreign_key: "follower_id"
#    has_many :followings, source: :followee


  has_many :active_relationships,  class_name:  "Relationship",
  foreign_key: "follower_id",
  dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
  foreign_key: "followee_id",
  dependent:   :destroy
  has_many :followings, through: :active_relationships,  source: :followee
  has_many :followers, through: :passive_relationships, source: :follower
  
  def following?(another_user)
    self.followings.include?(another_user)
  end

  def follow(another_user)
    # unless self == another_user
    #   self.relationships.find_or_create_by(followee_id: another_user.id)
    # end
    followings << another_user
  end
  
  def unfollow(another_user)
    # unless self == another_user
    #   relationship = self.relationships.find(followee_id: another_user.id)
    #   relationship.destroy if relationship
    # end
    active_relationships.find_by(followee_id: another_user.id).destroy
  end

end 