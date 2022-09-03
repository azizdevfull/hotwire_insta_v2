class Post < ApplicationRecord
  has_one_attached :file
  has_many :likes
  has_many :comments
  belongs_to :user

  validates :body, presence: true
  validates :file, presence: true

  after_create_commit do
    broadcast_prepend_to "posts_list",
      target: "posts",
      partial: "posts/post",
      locals: { post: self, user: nil }
  end
  # def likee
  #   post = likes.user.email
  # end
  def like!(user)
    likes << Like.new(user: user)
  end

  def unlike!(user)
    likes.find_by(user_id: user.id).destroy
  end

  def liked?(user)
    !!self.likes.find{|like| like.user_id==user.id}
  end
  def likee(user)
    likes.where(user: user.email)
  end
  def aziz(user)
    likes.user
  end
end
