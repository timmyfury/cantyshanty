Cantyshanty::Application.routes.draw do

  match 'rss' => 'home#rss', :format => :xml, :as => :rss
  match 'tag/:slug' => 'home#tag', :as => :tag
  match 'tag' => 'home#tag_cloud', :as => :tag_cloud
  match '_:slug' => 'home#image', :as => :short
  match 'tc/:slug' => 'home#legacy', :as => :legacy
  match 'page:page_num' => 'home#legacy_pages', :as => :legacy_pages

  resources :posts do
    put 'publish', :on => :member
    get 'attributed', :on => :collection
    get 'drafts', :on => :collection
    get 'published', :on => :collection
    get 'search', :on => :collection
    get 'unattributed', :on => :collection
    get 'unpublished', :on => :collection
  end

  root :to => "home#index"
  
  unless Cantyshanty::Application.config.consider_all_requests_local
    match '*a', :to => 'application#render_not_found'
  end

end
