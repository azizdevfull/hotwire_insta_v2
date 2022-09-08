class ProfileController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  include ProfileHelper
  before_action :set_user

  def index
    @users = User.all
    # @users = User.search(params[:term])
    # respond_to :js
  end
  def search
    @users = User.where("username like ?", "%#{params[:q]}%")
    render layout: false
  end

    def show
      @users = User.all
      # set_meta_tags title: @user.username

      # @posts = Post.all
      @user = User.friendly.find(params[:id])
      @posts = @user.posts.includes(:likes, :comments)
      # @posts = Post.all
      @bookmarks = Bookmark.all
      @saved = Post.joins(:bookmarks).where(user_id: current_user.id).includes(:likes, :comments) if @user == current_user
      # @users = User.all
      # @posts = Post.all
      # @bookmarks = Bookmark.all
    end

  def follow
    Relationship.create_or_find_by(follower_id: current_user.id, followee_id: @user.id)
    respond_to do |format|
      format.turbo_stream do
        # john doe with a user id of 2
        # dom_id_for_follower(@user) -> user_2
        render turbo_stream: [
          turbo_stream.replace(dom_id_for_follower(@user),
                               partial: 'profile/follow_button',
                               locals: { user: @user }),
          turbo_stream.update("#{@user.id}-follower-count",
                              partial: 'profile/follower_count',
                              locals: { user: @user })
        ]
      end
    end
  end

  def unfollow
    current_user.followed_users.where(follower_id: current_user.id, followee_id: @user.id).destroy_all
    respond_to do |format|
      format.turbo_stream do
        # john doe with a user id of 2
        # dom_id_for_follower(@user) -> user_2
        render turbo_stream: [
          turbo_stream.replace(dom_id_for_follower(@user),
                               partial: 'profile/follow_button',
                               locals: { user: @user }),
          turbo_stream.update("#{@user.id}-follower-count",
                              partial: 'profile/follower_count',
                              locals: { user: @user })
        ]
      end
    end
  end
  
  private

  def set_user
    @user = User.friendly.find(params[:id])
  end
end
