class ApplicationController < ActionController::Base
  protect_from_forgery
  
  unless config.consider_all_requests_local
    rescue_from ActiveRecord::RecordNotFound, :with => :render_not_found
    rescue_from ActionController::RoutingError, :with => :render_not_found
    rescue_from ActionController::UnknownController, :with => :render_not_found
    rescue_from ActionController::UnknownAction, :with => :render_not_found
  end

  def render_not_found
    @posts = Post.random(3, true)
    render :template => 'home/error_404', :status => 404
  end

end
