class StatusController < ApplicationController
  def get_status
    render :json => {status: 'OK'}
  end
end