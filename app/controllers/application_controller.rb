class ApplicationController < ActionController::Base
  protect_from_forgery
  
  unless config.consider_all_requests_local
    # rescue_from Exception, :with => :render_error
    rescue_from ActiveRecord::RecordNotFound, :with => :render_not_found
    rescue_from ActionController::RoutingError, :with => :render_not_found
    rescue_from ActionController::UnknownController, :with => :render_not_found
    rescue_from ActionController::UnknownAction, :with => :render_not_found
  end

private

  def render_not_found(exception)
    # log_error(exception)
    @posts = Post.random(3, true)
    render :template => 'home/error_404', :status => 404
  end

  # def render_error(exception)
  #   log_error(exception)
  #   render :template => "/error/500.html.erb", :status => 500
  # end

end
