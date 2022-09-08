class PostsController < ApplicationController
  before_action :find_post, only: [:show, :destroy]
  def index
    @posts = Post.order(created_at: :desc).all
    # @users = User.search(params[:term])
    # respond_to :js
    # @is_bookmarked = @post.is_bookmarked(current_user)
  end

  def new
    @post = Post.new
  end
def show
  @post = Post.find_by id: params[:id]
  set_meta_tags title: "Photo by "+@post.user.username

 
end

  def create
    @post = Post.new(post_params)
    current_user.posts << @post

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to root_path }
    end
  end
  def destroy
    @post = Post.find(params[:id])
      @post.destroy
  
      respond_to do |format|
        format.html { redirect_to root_path, notice: "Project was successfully destroyed." }
        format.json { head :no_content }
      end
    end
  private
  def find_post
    @post = Post.find_by id: params[:id]

    return if @post
    flash[:danger] = "Post not exist!"
    redirect_to root_path
  end

    def post_params
      params.require(:post).permit(:body, :file)
    end
end
