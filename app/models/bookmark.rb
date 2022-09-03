class Bookmark < ApplicationRecord
  belongs_to :post
  belongs_to :user
  
  after_create_commit do
    broadcast_update_to "posts_list",
      target: "bookmarks-post-count-#{post_id}",
      partial: "posts/bookmarks_count",
      locals: { count: post.bookmarks.count }
  end
  after_destroy_commit do
    broadcast_update_to "posts_list",
      target: "bookmarks-post-count-#{post_id}",
      partial: "posts/bookmarks_count",
      locals: { count: post.bookmarks.count }
  end
end
