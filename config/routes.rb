Rails.application.routes.draw do
  root 'static_pages#home'
  resources :users do
    collection do
      get 'checkemail'
      get 'switch_admin'
      get 'slack'
    end
  end
  resources :timelines, only: [:new, :create, :index, :show, :edit, :update, :destroy] do
    collection do
      get 'set_public'
      get 'switch_staging'
      get 'switch_favorite'
    end
  end
  resources :comments, only: [:show, :new, :create, :edit, :update, :destroy]
  resources :votes, only: [:new, :create, :destroy]
  resources :ratings, only: [:create, :destroy]
  resources :binaries, only: [:create, :destroy]
  resources :user_details, only: [:create]
  resources :sessions, only: [:new, :create, :destroy] do
    collection do
      get 'send_activation'
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :likes, only: [:create, :destroy, :index]
  resources :newsletters, only: [:create]
  resources :summaries, only: [:show, :index, :new, :create, :edit, :update, :destroy]
  resources :credits, only: [:new, :create, :destroy]
  resources :frames, only: [:show, :index, :new, :create, :edit, :update, :destroy]
  resources :frame_credits, only: [:new, :create, :destroy]
  resources :suggestions, only: [:index, :create, :show, :edit, :update, :destroy]
  resources :suggestion_children, only: [:create, :show, :edit, :update, :destroy]
  resources :suggestion_votes, only: [:create]
  resources :suggestion_child_votes, only: [:create]
  resources :issues, only: [:create]
  resources :reponses, only: [:create]
  resources :figures, only: [:create]
  resources :invitations, only: [:create, :new]
  resources :edges, only: [:index, :create]
  resources :edge_votes, only: [:create, :destroy]
  resources :reference_edges, only: [:index, :create]
  resources :reference_edge_votes, only: [:create, :destroy]
  resources :reference_user_tags, only: [:create, :update]
  resources :contributions, only: [:index]
  resources :typos, only: [:create, :new, :index, :show, :destroy]
  resources :pending_users, only: [:destroy]
  resources :references, only: [:new, :create, :show, :edit, :update, :destroy]
  resources :questions, only: [:create, :edit, :update, :destroy]
  resources :previews, only: [:create]
  resources :dead_links, only: [:create, :destroy, :index]
  resources :partners, only: [:new, :create, :edit, :destroy, :index, :update] do
    collection do
      post 'suggest'
    end
  end
  resources :partner_loves, only: [:create]
  post 'notifications/delete'
  delete 'logout' => 'sessions#destroy'
  get 'how_to' => 'static_pages#how_to'
  get 'how_to_edit' => 'static_pages#how_to_edit'
  get 'faq' => 'static_pages#faq'
  get 'terms' => 'static_pages#terms'
  get 'about' => 'static_pages#about'
  get 'transition-rhone-alpes' => 'static_pages#rhone_alpes'
  get 'markdown-tutorial' => 'static_pages#markdown_tutorial'
  get 'magna-charta' => 'static_pages#magna_charta', as: 'magna_charta'
  get 'empty_references' => 'static_pages#empty_references'
  get 'empty_summaries' => 'static_pages#empty_summaries'
  get 'empty_comments' => 'static_pages#empty_comments'
  get 'newsletter' => 'static_pages#newsletter'
  get 'login_for_admin' => 'sessions#as_admin'
  get 'signup' => 'users#new'
  get 'login' => 'sessions#new'
  get 'timelines_graph' => 'timelines#graph'
  get 'timelines_network' => 'timelines#network'
  get '/previous_reference' => 'references#previous', as: 'previous_reference'
  get '/next_reference' => 'references#next', as: 'next_reference'
  get '/next_timeline' => 'timelines#next', as: 'next_timeline'
  get '/next_user' => 'users#next', as: 'next_user'
  get '/previous_user' => 'users#previous', as: 'previous_user'
  get '/from_timeline' => 'references#from_timeline', as: 'from_timeline'
  get '/from_reference' => 'references#from_reference', as: 'from_reference'
  get 'references_graph' => 'references#graph'
  get 'references_network' => 'references#network'
  get 'timelines_download_bibtex' => 'timelines#download_bibtex'
  get 'assistant' => 'assistant#view'
  get 'assistant/users' => 'assistant#users'
  get 'assistant/index' => 'assistant#index'
  get 'assistant/timelines' => 'assistant#timelines'
  get 'assistant/fitness' => 'assistant#fitness'
  get 'assistant/selection' => 'assistant#selection'
  get 'assistant/profils' => 'assistant#profils'
  get 'notifications/index'
  get 'notifications/important'
  get 'notifications/delete_all'
  get 'notifications/delete_all_important'
  get 'notifications/timeline'
  get 'notifications/reference'
  get 'notifications/comment'
  get 'notifications/summary'
  get 'notifications/frame'
  get 'notifications/selection'
  get 'notifications/summary_selection'
  get 'notifications/frame_selection'
  get 'notifications/selection_redirect'
  get 'notifications/suggestion'
  get 'notifications/suggestions'
  get 'my_items/items'
  get 'my_items/votes'
  get "/fetch_children" => 'suggestion_children#from_suggestion', as: 'fetch_children'
  get 'typos_accept' => 'typos#accept', as: 'typos_accept'
  get 'feed' => 'timelines#feed', :as => "feed"
  if Rails.env.development?
    get '/public/uploads/:file', to: redirect { |path_params, req|
      "/uploads/#{path_params[:file]}.#{path_params[:format]}"
    }
  end
end
