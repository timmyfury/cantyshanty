class LegacyController < ApplicationController

  def image
    @post = Post.find_by_legacy_slug!(params[:slug])
    redirect_to short_url(:slug => @post.slug), :status => :moved_permanently
  end

  def page
    page = params[:page_num] || 1
    redirect_to root_path(:page => page), :status => :moved_permanently
  end

  def tag_cloud
    redirect_to tag_cloud_path, :status => :moved_permanently
  end

  def tag
    redirect_to tag_path(:page => params[:page], :slug => params[:slug]), :status => :moved_permanently
  end

end
