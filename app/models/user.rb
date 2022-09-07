class User < ApplicationRecord
  extend FriendlyId
   friendly_id :username, use: :slugged 
   has_many :posts
   has_many :comments
   has_many :likes
   has_many :bookmarks
   has_one_attached :avatar

   def should_generate_new_friendly_id?
    slug.blank? || username_changed?
  end


  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

         attr_writer :login
         validate :validate_username

         def login
           @login || self.username || self.email
         end
   
         def self.find_for_database_authentication(warden_conditions)
          conditions = warden_conditions.dup
          if (login = conditions.delete(:login))
            where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
          elsif conditions.has_key?(:username) || conditions.has_key?(:email)
            where(conditions.to_h).first
          end
        end 
        
        def validate_username
          if User.where(email: username).exists?
            errors.add(:username, :invalid)
          end
        end

    has_many :followed_users,
    foreign_key: :follower_id,
    class_name: 'Relationship',
    dependent: :destroy

has_many :followees, through: :followed_users, dependent: :destroy

has_many :following_users,
    foreign_key: :followee_id,
    class_name: 'Relationship',
    dependent: :destroy

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
end
