class UsersController < ApplicationController
 before_action :authenticate_request!,only: [:show]

  def create
    user = User.new(user_params)
    if user.save
      render json: {status: 'User created successfully'}, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :bad_request
    end
  end

  def login
    user = User.find_by(email: params[:email].to_s.downcase)
    if user && user.authenticate(params[:password])
      auth_token = JsonWebToken.encode({user_id: user.id})
      render json: {auth_token: auth_token}, status: :ok
    else
      render json: {error: 'Invalid username / password'}, status: :unauthorized
    end
  end

  def logout
    auth_token = ""
    @current_user = nil
    render json: {status: 'User logout successfully'}, status: :ok
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
