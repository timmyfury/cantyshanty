Cantyshanty::Application.routes.draw do

  match 'tag/:slug' => 'home#tag', :as => :tag
  match 'tag' => 'home#tag_cloud', :as => :tag_cloud
  match '_:slug' => 'home#image', :as => :short
  match 'tc/:slug' => 'home#legacy', :as => :legacy
  match 'page:page_num' => 'home#legacy_pages', :as => :legacy_pages

  match 'posts/:status' => 'posts#index', :constraints => { :status => /drafts|backlog|published|attributed|unattributed/ }, :as => :list

  resources :posts do
    put 'publish', :on => :member
  end

  root :to => "home#index"
  
  unless Cantyshanty::Application.config.consider_all_requests_local
    match '*a', :to => 'application#render_not_found'
  end

end
