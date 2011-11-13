class HomeController < ApplicationController

  def index
    @posts = Post.published.recent.paginate(:page => params[:page], :per_page => 7)
  end

  def tag
    @posts = Post.published.tagged_with(params[:slug]).paginate(:page => params[:page], :per_page => 7)
    @title = "Tagged #{@tag}"
  end

  def image
    @post = Post.find_by_slug(params[:slug])
    @title = "#{@post.title}"
  end

  def legacy
    @post = Post.find_by_legacy_slug(params[:slug])
    redirect_to short_url(:slug => @post.slug)
  end

end
