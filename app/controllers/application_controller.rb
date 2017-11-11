class ApplicationController < ActionController::API
  def unauthorized_request
    return render :json => {error: 'Unauthorized'}, status: 401
  end

  def input_error(param_name="N/A")
    p "input_error; param_name=#{param_name}"
    return render :json => {error: 'Input error'}, status: 400
  end


  def request_is_not_authorized
    # return request_is_authorized == false
    not request_is_authorized
  end

  def request_is_authorized
    # Secretkey.where(key: apiKey).empty?
    # this looks for the secret key that is passed as a request.header
    # if it is false, it means that there is a valid apiKey that matches the header

    # p "<<<<DEBUG-START All the headers"
    # p request.headers["apiKey"]
    # p request.headers
    # p "<<<<DEBUG-END All the headers"

    apiKey = request.headers["apiKey"]
    if Secretkey.where(key: apiKey).empty? == false
      return true
    else
      return false
    end
  end

  def is_invalid_float_param(param_name)
    # return is_valid_float_param(param_name) == false
    not is_valid_float_param(param_name)
  end

  # checks if the param is a float, if it is a float -> return true
  def is_valid_float_param(param_name)
    # this is the equivalent one-liner ruby-style
    # true if Float params[param_name] rescue false
    begin
      Float(params[param_name])
      return true
    rescue
      return false
    end
  end

  def is_invalid_string_param(param_name)
    not is_valid_string_param(param_name)
  end

  def is_valid_string_param(param_name)
    if params[param_name] == nil
      return false
    end
    params[param_name].empty? == false
  end
end
