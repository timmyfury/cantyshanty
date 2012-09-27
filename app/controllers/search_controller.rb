class SearchController < ApplicationController

  layout "public"

  def index
    @posts = Post.where(@q_args).order("title").paginate(:page => params[:page], :per_page => 30)

    render :list
  end

end
