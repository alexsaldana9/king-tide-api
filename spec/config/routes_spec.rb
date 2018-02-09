require 'rails_helper'

RSpec.describe 'routes', type: :routing do
  it 'work as expected' do
    expect(get: '/').to route_to('status#index')
    expect(get: '/status/').to route_to('status#index')


    expect(get: '/readings/all').to route_to('readings#all')
    expect(get: '/readings/approved').to route_to('readings#approved')
    expect(get: '/readings/pending').to route_to('readings#pending')
    expect(get: '/readings/12').to route_to(controller: 'readings', action: 'get', id: '12')

    expect(post: '/readings').to route_to('secure/readings#create')
    expect(post: '/readings/').to route_to('secure/readings#create')
    expect(post: '/readings/approve').to route_to('secure/readings#approve')
    expect(post: '/readings/approve/').to route_to('secure/readings#approve')

    expect(delete: '/readings').to route_to('secure/readings#delete')
    expect(delete: '/readings/').to route_to('secure/readings#delete')


    expect(post: '/photos').to route_to('secure/photos#create')
    expect(post: '/photos/').to route_to('secure/photos#create')
  end
end
