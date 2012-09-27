class HomeController < ApplicationController

  layout "public"

  def index
    @posts = Post.includes(:tags).published.recent.paginate(:page => params[:page], :per_page => 20)
    render :list
  end

  def rss
    @posts = Post.published.recent.paginate(:page => params[:page], :per_page => 20)
  end

  def about; end;

  def beacon
    @post = Post.includes(:tags).find_by_slug!(params[:slug])
    GoogleAnalytics.track("#{@post.title} | Canty Shanty", short_path(:slug => @post.slug), source='RSS', utma=cookies[:__utma])
    send_data(Base64.decode64("R0lGODlhAQABAPAAAAAAAAAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw=="), :type => "image/gif", :disposition => "inline")
  end

  def image
    @post = Post.find_by_slug!(params[:slug])
    respond_to do |format|
      format.html
    end
  end

end
