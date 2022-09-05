class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user, only: %i[ show edit update destroy ]
    def index
      @users = User.all
      # @users = User.search(params[:term])
      # respond_to :js
    end
    def search
      @users = User.where("username like ?", "%#{params[:q]}%")
    end
    # def search
    #   if params[:username_search].present?
    #     @users = User.filter_by_username(params[:username_search])
    #   else
    #     @users = []
    #   end
    #   respond_to do |format|
    #     format.turbo_stream do
    #       # render turbo_stream: turbo_stream.update("search_results", Time.zone.now)
    #       # render turbo_stream: turbo_stream.update("search_results", @movies.count)
    #       render turbo_stream: turbo_stream.update("search_results",
    #                               partial: "users/search_results", locals: { users: @users })
    #     end
    #   end
    # end
  
    # def show
    #   @user = User.find(params[:id])
    #   set_meta_tags title: @user.name
    #   @posts = @user.posts.includes(:photos, :likes, :comments)
    #   @saved = Post.joins(:bookmarks).where("bookmarks.user_id=?", current_user.id).
    #     includes(:photos, :likes, :comments) if @user == current_user
    # end
    def show
      @users = User.all
      @posts = Post.all
      @bookmarks = Bookmark.all
    end
    
    def profile
      @users = User.all
      @user = User.find(params[:id])
       @posts = Post.all
       @bookmarks = Bookmark.all
    #   respond_to :js
    end
  
    # def show
    #   @user = User.find(params[:id])
    #   set_meta_tags title: @user.name
    #   @posts = @user.posts.includes(:photos, :likes, :comments)
    #   @saved = Post.joins(:bookmarks).where("bookmarks.user_id=?", current_user.id).
    #     includes(:photos, :likes, :comments) if @user == current_user
    # end
    private
    def set_user
      @user = User.find(params[:id])
    end
  end