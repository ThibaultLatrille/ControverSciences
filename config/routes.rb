Rails.application.routes.draw do
  root 'timelines#index'
  resources :users do
    collection do
      get 'checkemail'
      get 'switch_admin'
      get 'slack'
      get 'destroy_confirmation'
    end
  end
  resources :timelines, only: [:new, :create, :index, :show, :edit, :update, :destroy] do
    collection do
      get 'set_public'
      get 'switch_staging'
      get 'switch_favorite'
      get 'invited'
      get 'mine'
    end
  end
  get 'controverses/:id' => 'timelines#show'
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
  resources :frames, only: [:show, :index, :new, :create, :edit, :update, :destroy] do
    collection do
      get 'destroy_binaries'
    end
  end
  resources :frame_credits, only: [:new, :create, :destroy]
  resources :issues, only: [:create]
  resources :figures, only: [:create] do
    collection do
      post 'identicon'
    end
  end
  resources :invitations, only: [:create, :new]
  resources :edges, only: [:index, :create]
  resources :edge_votes, only: [:create, :destroy]
  resources :reference_edges, only: [:index, :create]
  resources :reference_edge_votes, only: [:create, :destroy]
  resources :reference_user_tags, only: [:create, :update]
  resources :contributions, only: [:index]
  resources :patches, only: [:create, :show, :new, :index, :destroy]
  post 'patches_accept' => 'patches#accept', as: 'patches_accept'
  get 'patches_mine' => 'patches#mine', as: 'patches_mine'
  get 'patches_target' => 'patches#target', as: 'patches_target'
  get 'patches_modal' => 'patches#modal', as: 'patches_modal'
  resources :pending_users, only: [:destroy]
  resources :references, only: [:new, :create, :show, :edit, :update, :destroy]
  resources :questions, only: [:create, :edit, :update, :destroy] do
    collection do
      get 'down'
      get 'up'
    end
  end
  resources :previews, only: [:create]
  resources :dead_links, only: [:create, :destroy, :index]
  resources :private_timelines, only: [:index, :create] do
    collection do
      get 'add_current_user'
    end
  end
  resources :timeline_choices, only: [:create]
  resources :patch_messages, only: [:destroy]
  resources :user_patches, only: [:index]
  post 'notifications/delete'
  delete 'logout' => 'sessions#destroy'
  get 'voronoi' => 'static_pages#voronoi'
  get 'identicon' => 'static_pages#voronoi'
  get 'jesus-christ-my-savior' => 'static_pages#rick_roll'
  get 'faq' => 'static_pages#faq'
  get 'terms' => 'static_pages#terms'
  get 'about' => 'static_pages#about'
  get 'home' => 'static_pages#home'
  get 'AREN' => 'static_pages#aren'
  get 'discover' => 'static_pages#discover'
  get 'comics' => 'static_pages#comics'
  get 'student-demo-cup' => 'presentations#student_demo_cup_intro'
  get 'student-demo-cup-protocol' => 'presentations#student_demo_cup_protocol'
  get 'student-demo-cup-controversciences' => 'presentations#student_demo_cup_core'
  get 'student-demo-cup-outro' => 'presentations#student_demo_cup_outro'
  get 'markdown-tutorial' => 'static_pages#markdown_tutorial'
  get 'magna-charta' => 'static_pages#magna_charta', as: 'magna_charta'
  get 'empty_references' => 'static_pages#empty_references'
  get 'empty_summaries' => 'static_pages#empty_summaries'
  get 'empty_comments' => 'static_pages#empty_comments'
  get 'newsletter' => 'static_pages#newsletter'
  get 'login_for_admin' => 'sessions#as_admin'
  get 'signup' => 'users#new'
  get 'social_buttons' => 'users#social_buttons'
  get 'login' => 'sessions#new'
  get 'tag-pairs-graph' => 'tag_pairs#graph'
  get 'reference-pairs' => 'tag_pairs#reference_pairs'
  get 'timeline-pairs' => 'tag_pairs#timeline_pairs'
  get 'timelines_graph' => 'timelines#graph'
  get 'timelines_network' => 'timelines#network'
  get 'users_network' => 'users#network'
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
  get 'timelines_download_pdf' => 'timelines#download_pdf'
  get 'timelines_download_tex' => 'timelines#download_tex'
  get 'assistant' => 'assistant#view'
  get 'assistant/users' => 'assistant#users'
  get 'assistant/index' => 'assistant#index'
  get 'assistant/timelines' => 'assistant#timelines'
  get 'assistant/fitness' => 'assistant#fitness'
  get 'assistant/selection' => 'assistant#selection'
  get 'assistant/profils' => 'assistant#profils'
  get 'assistant/pdflatex' => 'assistant#pdflatex'
  get 'assistant/pdftimlatex' => 'assistant#pdftimlatex'
  post 'assistant/partial_tex' => 'assistant#partial_tex'
  get 'notifications/index'
  get 'notifications/news'
  get 'notifications/patches'
  get 'notifications/redirect'
  get 'notifications/delete_all'
  get 'notifications/important'
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
  get 'my_items/items'
  get 'my_items/votes'
  get 'feed' => 'timelines#feed', :as => "feed"
  get 'unsuscribe_email' => 'user_details#unsuscribe', as: 'unsuscribe_email'
  if Rails.env.development?
    get '/public/uploads/:file', to: redirect { |path_params, req|
      "/uploads/#{path_params[:file]}.#{path_params[:format]}"
    }
  end
end
