class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user, only: %i[ show edit update destroy ]
    def index
      @users = User.all
      # @users = User.search(params[:term])
      # respond_to :js
    end
    def update
      logger.info "UsersController#update"
          
      # Override Devise to use update_attributes instead of update_with_password.
      # This is the only change we make.
      if resource.update_attributes(params[resource_name])
        set_flash_message :notice, :updated
        # Line below required if using Devise >= 1.2.0
        sign_in resource_name, resource, :bypass => true
        redirect_to profile_path
      else
        clean_up_passwords(resource)
        render_with_scope :edit
      end
    end
    def search
      @users = User.where("username like ?", "%#{params[:q]}%")
      render layout: false
    end

    def show
      @users = User.all
      @posts = @user.posts.includes(:likes, :comments)
      # @posts = Post.all
      @bookmarks = Bookmark.all
      @saved = Post.joins(:bookmarks).where(user_id: current_user.id).
      includes(:file, :likes, :comments) if @user == current_user
    end
    
    def profile
      @users = User.all
      @user = User.find(params[:id])
       @posts = Post.all
       @bookmarks = Bookmark.all
    end

    private
    def set_user
      @user = User.friendly.find(params[:id])
    end
  end