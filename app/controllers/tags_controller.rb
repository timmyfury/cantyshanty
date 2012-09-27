class TagsController < ApplicationController

  layout "public"

  def index
    @tags = Post.published.tag_counts.sort{|x, y| x.name.downcase <=> y.name.downcase }

    respond_to do |format|
      format.html
      format.json { render json: @tags }
    end
  end

  def show
    @posts = Post.published.tagged_with(params[:slug]).paginate(:page => params[:page], :per_page => 20)
  end

end
