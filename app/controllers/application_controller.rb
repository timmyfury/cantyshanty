class ApplicationController < ActionController::Base

  protect_from_forgery

  before_filter :parse_search_params

  def list
    respond_to do |format|
      format.html
      format.json { render json: @posts }
    end
  end
  
private

  def parse_search_params
    @q = params[:q] ? params[:q].downcase : ''

    patterns = []
    terms = []

    @q.split.each do |t|
      patterns.push 'search LIKE ?'
      terms.push "%#{t}%"
    end

    @q_args = terms.unshift(patterns.join(" AND "))
  end

end
