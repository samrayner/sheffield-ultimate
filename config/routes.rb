SheffieldUltimate::Application.routes.draw do
  resources :emails, only: [:new, :create]
  get '/contact' => 'emails#new'
  get '/events' => 'events#feed'

  ComfortableMexicanSofa::Routing.admin(:path => '/cms-admin')
  # Make sure this routeset is defined last
  ComfortableMexicanSofa::Routing.content(:path => '/', sitemap: false)
end
