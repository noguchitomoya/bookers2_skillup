class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  attachment :profile_image, destroy: false
  has_many :books
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  validates :name, presence: true, length: {maximum: 10, minimum: 2}
  validates :introduction, length: {maximum: 50}
  
  # # フォロワー
#  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'followee_id'
#   has_many :followers, source: :follower

  
#   # フォローしている人
#    has_many :relationships, foreign_key: "follower_id"
#    has_many :followings, source: :followee
has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy # ① フォローしている人取得(Userのfollowerから見た関係)
has_many :followee, class_name: "Relationship", foreign_key: "followee_id", dependent: :destroy # ② フォローされている人取得(Userのfoloweeから見た関係)

has_many :following_user, through: :follower, source: :followee # 自分がフォローしている人
has_many :follower_user, through: :followee, source: :follower # 自分をフォローしている人(自分がフォローされている人)


  
  def following?(another_user)
    self.following_user.include?(another_user)
  end

  def follow(another_user)
    # unless self == another_user
    #   self.follower.find_or_create_by(followee_id: another_user.id)
    # end
    follower.create(followee_id: another_user.id)
  end
  
  def unfollow(another_user)
    # unless self == another_user
    #   follower = self.follower.find_by(followee_id: another_user.id)
    #   follower.destroy if follower
    # end
  
    follower.find_by(followee_id: another_user.id).destroy
  end

end 