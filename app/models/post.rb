class Post < ApplicationRecord
  has_one_attached :file
  has_many :likes
  has_many :comments
  has_many :bookmarks
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
  def bookmark!(user)
    bookmarks << Bookmark.new(user: user)
  end
  

  def unlike!(user)
    likes.find_by(user_id: user.id).destroy
  end
  def unbookmark!(user)
    bookmarks.find_by(user_id: user.id).destroy
  end
  
  def liked?(user)
    !!self.likes.find{|like| like.user_id==user.id}
  end
  def bookmarked?(user)
    !!self.bookmarks.find{|bookmark| bookmark.user_id==user.id}
  end
  

  # def likee(user)
  #   likes.where(user: user.email)
  # end
  # def aziz(user)
  #   likes.user
  # end
  # def is_bookmarked(user)
  #   Bookmark.find_by(user_id: user.id, post_id: id)
  # end
end
