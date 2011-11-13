class PostsController < ApplicationController
  layout "admin"
  
  before_filter :authenticate
  before_filter :get_post_counts
  
  def get_post_counts
    @published_count = Post.published.count
    @backlog_count = Post.backlog.count
    @draft_count = Post.drafts.count
  end
  
  # GET /posts
  # GET /posts.json
  def index
    @status = params[:status] || 'drafts'

    if @status == 'published'
      @posts = Post.published.recently_updated.paginate(:page => params[:page], :per_page => 30)
    elsif @status == 'backlog'
      @posts = Post.backlog.recently_updated.paginate(:page => params[:page], :per_page => 30)
    else # draft
      @posts = Post.drafts.recently_updated.paginate(:page => params[:page], :per_page => 30)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])
    @status = @post.status

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new
    @status = 'upload'

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(params[:post])

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render @post }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def publish
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.publish
        format.html { redirect_to @post, notice: 'Post was successfully published.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :ok }
    end
  end

  protected
    def authenticate
      authenticate_or_request_with_http_basic do |username, password|
        username == "donkey" && password == "h33haw"
      end
    end

end
