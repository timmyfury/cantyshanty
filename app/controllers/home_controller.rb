class HomeController < ApplicationController

  layout "public"

  def list
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  def index
    @posts = Post.published.recent.paginate(:page => params[:page], :per_page => 20)
    render :list
  end

  def search
    @q = params[:q].downcase || ''

    patterns = []
    terms = []

    @q.split.each do |t|
      patterns.push 'search LIKE ?'
      terms.push "%#{t}%"
    end

    args = terms.unshift(patterns.join(" AND "))

    @posts = Post.where(*args).order("title").paginate(:page => params[:page], :per_page => 30)
    render :list
  end

  def about; end;

  def rss
    @posts = Post.published.recent.paginate(:page => params[:page], :per_page => 20)
  end

  def tag_cloud
    @tags = Post.published.tag_counts.sort{|x, y| x.name.downcase <=> y.name.downcase }
  end

  def tag
    @posts = Post.published.tagged_with(params[:slug]).paginate(:page => params[:page], :per_page => 20)
  end

  def image
    @post = Post.find_by_slug!(params[:slug])
  end

  def legacy
    @post = Post.find_by_legacy_slug!(params[:slug])
    redirect_to short_url(:slug => @post.slug)
  end

  def legacy_pages
    page = params[:page_num] || 1
    redirect_to root_path(:page => page)
  end

end
