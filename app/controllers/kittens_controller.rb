class KittensController < ApplicationController
  before_action :authenticate_request!,only: [:create, :update, :destroy]

  def index
    @kittens = Kitten.all
    render :json => @kittens
  end

  def create
    kitten = @current_user.kittens.build(kitten_params)
    if kitten.save
      render json: {status: 'Kitten created successfully'}, status: :created
    else
      render json: { errors: kitten.errors.full_messages }, status: :bad_request
    end
  end

  def update
    @kitten = Kitten.find(params[:id]) 
      if current_user?(@kitten.user)
        if @kitten.update_attributes(kitten_params) 
          render json: {status: 'Kitten updated successfully'}, status: :updated
        else
          render json: { errors: @kitten.errors.full_messages }, status: :bad_request
        end
      else
        render json: { errors: "You are not authorized to update this kitten" }, status: :bad_request
      end
    rescue ActiveRecord::RecordNotFound => e
    render json: {
      error: e.to_s
    }, status: :not_found
  end

  def show
     @kitten = Kitten.find(params[:id])
    render json: @kitten
    rescue ActiveRecord::RecordNotFound => e
    render json: {
      error: e.to_s
    }, status: :not_found
  end

  def destroy
   if  @kitten = Kitten.find(params[:id]) 
      if current_user?(@kitten.user)
        if @kitten.destroy
          render json: {status: 'Kitten Deleted successfully'}, status: :updated
        else
          render json: { errors: @kitten.errors.full_messages }, status: :bad_request
        end
      else
        render json: "You can't delete this kitten", status: :bad_request
      end
    else
      render json: "Kitten Does not exists", status: :bad_request
    end
  end


  private

  def kitten_params
    params.require(:kitten).permit(:name, :age, :cuteness, :softness, :image)
  end
end


