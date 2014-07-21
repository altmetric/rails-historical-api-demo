GnipHistoricalManagerator::Application.routes.draw do
  root 'home#show'

  resources :jobs do
    collection do
      get :download
    end
  end

  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
end
