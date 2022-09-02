class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts
  has_many :comments
  has_many :likes
  has_one_attached :avatar

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
end
