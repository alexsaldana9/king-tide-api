Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  root to: 'readings#status'
  get 'readings/status', to: 'readings#status'

  get 'users/all', to: 'users#getall'
  get 'users/:id', to: 'users#get'
  post 'users/', to: 'users#create'
  put  'users/', to: 'users#update'
  delete 'users/', to: 'users#delete'


  get 'readings/all', to: 'readings#getall'
  get 'readings/:id', to: 'readings#get'
  post 'readings/', to: 'readings#create'
  put 'readings/', to: 'readings#update'
  delete 'readings/', to: 'readings#delete'

end
