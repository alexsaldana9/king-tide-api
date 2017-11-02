class UsersController < ApplicationController

  def getall
    # @page = params[:page] ? params[:page].to_i : 1
    @message = 'All users'
    @users = User.all.each
    # @count = @users.count
    # render :getall, status: :ok

    render :json => @users
  end

  def get
    @message = 'User'
    @users = User.find_by(id: params[:id])
    # render :get, status: :ok

    render :json => @users
  end

  def create
    @message = 'User Created'
    @user = User.new(user_params)
    # render :create, status: :ok

    render :json => @user
  end

  def update
    @message = 'Updated User'
    @user = User.find_by(id: params[:id])
    if @user.update(user_params)

    render :update, status: :ok
    end
  end

  def delete
    @message = 'User Deleted'
    render :delete, status: :ok
  end

  def user_params
    params.permit(:firstName, :lastName)
  end

end

