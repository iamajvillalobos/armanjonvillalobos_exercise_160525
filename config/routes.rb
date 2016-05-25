Rails.application.routes.draw do
  namespace :api do
    jsonapi_resources :users do
      jsonapi_resources :group_events
    end
  end
end