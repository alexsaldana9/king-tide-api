class ApplicationController < ActionController::API

  def request_is_authorized

    # Secretkey.where(key: apiKey).empty?
    # this looks for the secret key that is passed as a request.header
    # if it is false, it means that there is a valid apiKey that matches the header

    apiKey = request.headers["apiKey"]
    if Secretkey.where(key: apiKey).empty? == false
      return true
    else
      return false
    end
  end

end
