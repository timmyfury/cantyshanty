class ApplicationController < ActionController::Base
  protect_from_forgery

  def not_found
    @posts = Post.random(3, true).paginate(:page => params[:page], :per_page => 20)
    render :template => 'home/error_404', :status => 404
  end

end
