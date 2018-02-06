Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'status#index'

  resources :status

  get 'readings/all', to: 'readings#all'
  get 'readings/approved', to: 'readings#approved'
  get 'readings/pending', to: 'readings#pending'
  get 'readings/:id', to: 'readings#get'

  post 'readings/', to: 'secure/readings#create'
  post 'readings/approve', to: 'secure/readings#approve'
  delete 'readings/', to: 'secure/readings#delete'

  post 'photos/', to: 'secure/photos#create'

end
