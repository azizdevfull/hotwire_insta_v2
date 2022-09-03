class BookmarksController < ApplicationController
  before_action :find_post

  def create
    @post.bookmark!(current_user)
    @post.reload
    @user = current_user
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to root_path }
    end
  end

  def destroy
    @post.unbookmark!(current_user)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to root_path }
    end
  end

  private

    def find_post
      @post = Post.find(params.require(:id))
    end
  end