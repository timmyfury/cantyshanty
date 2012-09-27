class ErrorsController < ApplicationController

  layout "public"

  before_filter :get_random_posts

  def not_found
    render :status => 404
  end

  def rejected
    render :status => 422
  end

  def internal_server
    render :status => 500
  end

private

  def get_random_posts
    @posts = Post.random(3, true).paginate(:page => 1, :per_page => 3)
  end

end