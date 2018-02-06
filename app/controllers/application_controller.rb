class ApplicationController < ActionController::API
  def input_error(param_name="N/A")
    p "input_error; param_name=#{param_name}"
    return render :json => {error: 'Input error'}, status: 400
  end

  def not_found(message)
    p "not_found; reason= #{message}"
    return render :json => {error: 'Not found'}, status: 404
  end

  def validate_authorization
    if not SecretKey.is_valid(request.headers['apiKey'])
      render :json => {error: 'Unauthorized'}, status: 401
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
