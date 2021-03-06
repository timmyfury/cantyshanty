class PostsController < ApplicationController
  layout "admin"
  
  before_filter :authenticate
  before_filter :get_post_counts
  
  def list
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  def attributed
    @posts = Post.attributed.recently_updated.paginate(:page => params[:page], :per_page => 30)
    render :list
  end

  def drafts
    @posts = Post.drafts.recently_updated.paginate(:page => params[:page], :per_page => 30)
    render :list
  end

  def published
    @posts = Post.published.recently_updated.paginate(:page => params[:page], :per_page => 30)
    render :list
  end

  def search
    @posts = Post.where(@q_args).order("title").paginate(:page => params[:page], :per_page => 30)
    render :list
  end

  def unattributed
    @posts = Post.unattributed.recently_updated.paginate(:page => params[:page], :per_page => 30)
    render :list
  end

  def unpublished
    @posts = Post.unpublished.recently_updated.paginate(:page => params[:page], :per_page => 30)
    render :list
  end

  def index
    @posts = Post.random(30, false).paginate(:page => params[:page], :per_page => 20)
    render :list
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])
    @tags = Post.published.tag_counts.sort{|x, y| y.count <=> x.count }
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
        format.json { 
          render json: JSON::parse(@post.to_json(
                                            :only => [:id, :created_at, :updated_at, :image_file_name], 
                                            :methods => [:image_sizes]
                                          )).merge({"queue_position" => params[:uploadPosition] }).to_json,
                 status: :created, 
                 location: @post
        }
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
        Twitter.update("#{@post.title} #{short_url(:slug => @post.slug)}")
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
        username == ENV['CANTYSHANTY_AUTH_USERNAME'] && password == ""
      end
    end

    def get_post_counts
      @status = params[:action] == 'index' ? 'backlog' : params[:action]
      @attributed_count = Post.attributed.count
      @backlog_count = Post.backlog.count
      @draft_count = Post.drafts.count
      @published_count = Post.published.count
      @unattributed_count = Post.unattributed.count
      @unpublished_count = Post.unpublished.count
    end
end
