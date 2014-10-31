SheffieldUltimate::Application.routes.draw do
  resources :emails, only: [:new, :create] do
    collection do
      post :subscribe
    end
  end

  get '/contact' => 'emails#new'
  get '/events' => 'events#feed'

  if Rails.env.development?
    get '/rails/mailers'         => "rails/mailers#index"
    get '/rails/mailers/*path'   => "rails/mailers#preview"
  end

  comfy_route :cms_admin, path: '/admin'
  comfy_route :cms, path: '/', sitemap: false
end
