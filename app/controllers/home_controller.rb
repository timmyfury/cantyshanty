class HomeController < ApplicationController

  layout "public"

  def index
    @posts = Post.published.recent.paginate(:page => params[:page], :per_page => 7)
    @canonical = root_url
  end

  def tag_cloud
    @tags = Post.published.tag_counts.sort{|x, y| x.name.downcase <=> y.name.downcase }
  end

  def tag
    @posts = Post.published.tagged_with(params[:slug]).paginate(:page => params[:page], :per_page => 30)
    @title = "Tagged: #{params[:slug]}"
    @canonical = tag_url(:slug => params[:slug])
  end

  def image
    @post = Post.find_by_slug(params[:slug])
    @title = "#{@post.title}"
    @canonical = short_url(:slug => @post.slug)
  end

  def legacy
    @post = Post.find_by_legacy_slug(params[:slug])
    redirect_to short_url(:slug => @post.slug)
  end

  def legacy_pages
    page = params[:page_num] || 1
    redirect_to root_path(:page => page)
  end

end
