SheffieldUltimate::Application.routes.draw do
  resources :emails, only: [:new, :create]
  get '/contact' => 'emails#new'
  get '/events' => 'events#feed'

  comfy_route :cms_admin, path: '/admin'
  comfy_route :cms, path: '/', sitemap: false
end
