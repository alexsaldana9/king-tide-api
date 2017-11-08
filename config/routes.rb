Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'readings#getall'

  get 'status/get', to: 'status#get_status'

  get 'readings/all', to: 'readings#getall'
  get 'readings/:id', to: 'readings#get'
  post 'readings/', to: 'readings#create'
  put 'readings/', to: 'readings#update'
  delete 'readings/', to: 'readings#delete'

end
