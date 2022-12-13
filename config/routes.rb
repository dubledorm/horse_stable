Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks', registrations: 'users/registrations' }
  devise_scope :user do
    get '/users/auth/do_omniauth', to: 'omniauth_callbacks#do_omniauth', as: :auth_callback_do
    get '/users/auth/service_sign_up', to: 'omniauth_callbacks#service_sign_up_users', as: :service_sign_up_users
    post '/users/auth/create_user_and_service', to: 'omniauth_callbacks#create_user_and_service', as: :create_user_and_service
  end

  #  mount ActionCable.server => '/cable'

  namespace :api do
    resources :test_tasks, only: [:update] do
      collection do
        get :get_task
      end
    end
  end

  namespace :front do
    get 'get_parameters/:name', to: 'functions#get_parameters', as: 'functions_get_parameters'
    get 'experiment_current_state', to: 'experiments#experiment_current_state', as: 'experiment_current_state'
    get 'experiment_last_result', to: 'experiments#experiment_last_result', as: 'experiment_last_result'
    get 'experiment_history_list', to: 'experiments#experiment_history_list', as: 'experiment_history_list'

    put 'update_variables', to: 'experiment_test_environments#update_variables', as: 'update_environment_variables'

    resources :experiments, only: [] do
      resources :experiment_test_environments, only: %i[create index]
    end

    resources :projects, only: [] do
      resources :test_environments
    end
  end

  get 'documentation', to: 'documentation#index', as: 'documentation'

#  authenticated(:user) do

  resource :user_profile, only: %i[show update], controller: 'user_profile/users', as: :user_profile
  scope module: :user_profile do
    resources :services, only: [:destroy], as: :user_profile_services
  end

  resource :user_cabinet, only: %i[show update], controller: 'user_cabinet/users', as: :user_cabinet
  namespace :user_cabinet do
    resources :experiments, except: [:edit] do
      member do
        post :clone
        patch :update_categories
        patch :update_groups
        post :add_set_of_variable
      end
      resources :experiment_cases, except: %i[index edit] do
        member do
          post :clone
        end
      end
      resources :experiment_test_environments
    end

    resources :experiment_cases, only: [] do
      resources :operations, except: %i[index edit], shallow: true do
        member do
          put :function_update
        end
      end
    end

    resources :test_tasks
    resources :galleries
    resources :categories
    resources :user_groups
    resources :articles
    resources :some_files
  end


    # patch 'users/:id/update_category', to: 'user_cabinet/users#update_category', as: :user_update_category
    #
    # resources :users, only: [:show, :edit, :update] do
    #   get :profile, on: :member, to: 'user_profile/users#show', as: :user_profile
    #   put :profile, on: :member, to: 'user_profile/users#update'
    #
    #   scope module: 'user_profile' do
    #     resources :services, only: [:destroy]
    #   end
    #
    #   get :cabinet, on: :member, to: 'user_cabinet/users#show', as: :user_cabinet
    #   scope module: 'user_cabinet' do
    #     resources :galleries
    #     resources :pictures
    #   end
    #
    #   resources :articles
    # end
    #
    # resources :grades
    # resources :articles, only: [:index, :show]
#    root to: "secret#index", as: :authenticated_root
#  end

  resources :grades, only: %i[index show]
  resources :articles, only: %i[index show]
  resources :galleries, only: %i[index show]
  root to: 'home#index'

  def authenticated_root
    user_profile
  end
end

