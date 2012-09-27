Cantyshanty::Application.routes.draw do

  # tags
  match 'tags/:slug' => 'tags#show', :as => :tag
  match 'tags' => 'tags#index', :as => :tag_cloud

  # entries
  match '_*slug/beacon' => 'home#beacon', :format => :gif, :as => :beacon
  match '_*slug' => 'home#image', :as => :short

  # search
  match 'search' => 'search#index', :as => :search

  # legacy views
  match 'tc/:slug' => 'legacy#image'
  match 'page:page_num' => 'legacy#page'
  match 'tag/:slug' => 'legacy#tag'
  match 'tag' => 'legacy#tag_cloud'

  # posts admin
  resources :posts do
    put 'publish', :on => :member
    get 'attributed', :on => :collection
    get 'drafts', :on => :collection
    get 'published', :on => :collection
    get 'search', :on => :collection
    get 'unattributed', :on => :collection
    get 'unpublished', :on => :collection
  end

  # home
  match 'about' => 'home#about', :as => :about
  match 'rss' => 'home#rss', :format => :xml, :as => :rss
  root :to => "home#index"

  # errors
  match "/404", :to => "errors#not_found"
  match "/422", :to => "errors#rejected"
  match "/500", :to => "errors#internal_server"

end
