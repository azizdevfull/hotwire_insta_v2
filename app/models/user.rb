class User < ApplicationRecord
  extend FriendlyId
   friendly_id :username, use: :slugged 
 
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts
  has_many :comments
  has_many :likes
  has_many :bookmarks
  has_one_attached :avatar

    # This access the Relationship object.
    has_many :followed_users,
    foreign_key: :follower_id,
    class_name: 'Relationship',
    dependent: :destroy

# This accesses the user through the relationship object.
has_many :followees, through: :followed_users, dependent: :destroy

# This access the Relationship object.
has_many :following_users,
    foreign_key: :followee_id,
    class_name: 'Relationship',
    dependent: :destroy

# This accesses the user through the relationship object.
has_many :followers, through: :following_users, dependent: :destroy

  after_commit :add_default_avatar, on: %i[create update]

  def avatar_thumbnail
    avatar
  end

  def chat_avatar
    avatar
  end

  private

  def add_default_avatar
    return if avatar.attached?

    avatar.attach(
      io: File.open(Rails.root.join('app', 'assets', 'images', 'car1.jpg')),
      filename: 'car1.jpg',
      content_type: 'image/jpg'
    )
  end
  def self.search(q)
  end
  # scope :filter_by_username, -> (username) { where('username LIKE ?', "%#{username}%") }

  # def self.search(params)
  #   params[:query].blank? ? all : where(
  #     "name LIKE ?", "%#{sanitize_sql_like(params[:query])}%"
  #   )
  # end
  # def self.search(term)
  #   if term
  #     where('username LIKE ?', "%#{term}%")
  #   else
  #     nil
  #   end
  # end
end
