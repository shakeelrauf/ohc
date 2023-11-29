# frozen_string_literal: true

Rails.application.routes.draw do
  root 'admin/home#index'

  resources :passwords, except: %i[show] do
    collection do
      get :unrecognised
      get :updated
    end
  end

  scope module: :admin, path: :admin do
    root to: 'home#index', as: :admin_root

    # Camp Management
    resources :camp_locations do
      resources :children, only: %i[index]
      resources :seasons, except: %i[show]
    end

    resources :welcome_videos, except: %i[show]

    resources :seasons, only: [] do
      resources :camps, except: %i[show]
    end

    resources :camps, only: [] do
      resources :attendances, module: :camps
      resources :cabins
      resources :media_items, except: %i[show]

      resources :imports, module: :camps, only: %i[new create show] do
        get :template_csv, on: :collection
      end
    end

    # Admin Settings
    resources :admins, except: %i[show]

    resources :children, except: %i[show]

    resources :color_themes, except: %i[show]

    resources :conversations, only: %i[index show]

    namespace :users do
      resources :sessions, only: %i[create destroy]
      resource :merge, only: %i[new create]
    end

    # Content Management
    resources :camper_questions, except: %i[new create show]

    scope ':event_type', constraints: { event_type: /national|camp|cabin/ }, defaults: { event_type: 'national' } do
      resources :events, except: %i[show] do
        member do
          put :start
          put :open
          put :stop
        end

        resources :push_notifications, module: :events, only: %i[new create]
      end
    end

    resources :media_items, except: %i[show]

    resources :themes

    resources :quiz_questions, only: %i[edit update destroy]

    resources :settings, only: %i[index edit update]

    resources :streams, except: %i[show] do
      member do
        put :stop
      end
    end

    resources :tenants, except: %i[show] do
      get :switch, on: :member
      get :reset, on: :collection
    end

    resources :users, only: %i[] do
      resources :attendances, module: :users, only: %i[index destroy]
      resources :scores, module: :users, only: %i[index]
    end

    resources :comet_chat_reviews
  end

  namespace :api do
    namespace :v1 do
      resource :version, controller: :version

      namespace :users do
        resource :sessions, only: %i[show destroy]
      end
    end

    namespace :v2 do
      # Camp Endpoints
      resources :attendances, param: :code, only: %i[show create]
      resources :camp_locations, only: %i[] do
        resources :camps, only: %i[index]
      end

      # Content Endpoints
      resource :contact, only: %i[create]
      resources :camper_questions, only: %i[index create] do
        get :unread, on: :collection
      end
      resources :events, only: %i[index show]
      resources :media_items, only: %i[index]
      resources :themes, only: %i[index] do
        resources :quiz_questions, only: %i[index]
      end
      resources :scores, only: %i[index create]

      # User Management Endpoints
      resource :user, only: %i[show update]

      namespace :admin do
        resources :groups, only: %i[create]
        resources :camps, only: %i[show] do
          resources :cabins, only: %i[index]
        end

        resources :events, only: %i[create update destroy] do
          resources :push_notifications, module: :events, only: %i[create]
        end

        resources :seasons, only: %i[index]
        resources :streams, only: %i[index]
      end

      namespace :authentications do
        resource :sessions, only: %i[create show destroy]
        resources :passwords, param: :reset_token, only: %i[create show update]
      end

      resources :authentications, only: %i[create] do
        collection do
          get :check_username
        end
      end

      resources :users, param: :chat_uid, only: [] do
        resources :messages, only: %i[destroy]
      end

      namespace :users do
        resource :device_token, only: %i[create]
        resources :conversations, only: %i[index]
        resources :reachable_users, only: %i[index]
      end

      resources :settings, only: :index
    end
  end

  # Nice login/logout routes
  get 'login'    => 'admin/users/sessions#new',      as: :login
  get 'logout'   => 'admin/users/sessions#destroy',  as: :logout
end
