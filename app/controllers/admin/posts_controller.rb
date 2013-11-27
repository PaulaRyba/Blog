class Admin::PostsController < AdminController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @posts = Post.all
  end

  def show
  end


  def new
    @post = Post.new
  end


  def edit
  end

  def create
    @post = Post.new

      begin
        post_service(@post).process(params[:post][:title], params[:post][:content], params[:post][:category_id])
        redirect_to [:admin, @post]
      rescue PostService::PostError
        flash.now[:notice]=  'Something went wrong'
        render 'new' 
      rescue PostService::TitleEmpty
        flash.now[:notice]=  'Title is empty'
        render 'new'
      rescue PostService::ContentNotValid
        flash.now[:notice]= 'Content is empty or too short'
        render 'new'
      rescue PostService::CategoryNotValid
        flash.now[:notice]= 'Category is empty'
        render 'new'
      end
  end


  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to [:admin,@post], notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :content, :category_id)
    end

    def post_service(post)
      PostService.new(post)
    end
end
