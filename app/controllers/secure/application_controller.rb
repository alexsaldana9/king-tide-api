class Secure::ApplicationController < ApplicationController
  before_action :authorize

  private

  def authorize
    if not SecretKey.is_valid(request.headers['apiKey'])
      render :json => {error: 'Unauthorized'}, status: 401
    end
  end
end