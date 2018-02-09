class ApplicationController < ActionController::API
  def success
    return render :json => { status: :ok }
  end

  def input_error(param_name='N/A', reason='N/A')
    logger.info "input_error; param_name=#{param_name}; reason=#{reason}"
    return render :json => {error: 'Input error'}, status: 400
  end

  def not_found(message='record not found')
    logger.info "not_found; reason= #{message}"
    return render :json => {error: 'Not found'}, status: 404
  end

  def client_error(message='N/A', status_code=400)
    logger.info "client_error; reason= #{message}"
    return render :json => { error: message }, status: status_code
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
    if not params[param_name]
      return false
    end
    params[param_name].empty? == false
  end

  def cache_action(key, expiration=15.seconds)
    Rails.cache.fetch(key, expires_in: expiration) do
      yield
    end
  end
end
