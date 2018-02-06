Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'readings#get_all'

  get 'status/get', to: 'status#get_status'

  get 'readings/all', to: 'readings#get_all'
  get 'readings/approved', to: 'readings#get_all_approved'
  get 'readings/pending', to: 'readings#get_pending'
  get 'readings/:id', to: 'readings#get'

  post 'readings/', to: 'secure/readings#create'
  post 'readings/approve', to: 'secure/readings#approve'
  delete 'readings/', to: 'secure/readings#delete'

  post 'photos/', to: 'secure/photos#create'

end
