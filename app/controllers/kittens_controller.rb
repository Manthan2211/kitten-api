class KittensController < ApplicationController
  before_action :authenticate_user,except: :index
  
  def index
    @kittens = Kitten.all
    render :json => @kittens.as_json( :except => [:created_at, :updated_at], 
                            :methods => [:like_count])
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
    render json: @kitten.as_json(except: [:created_at, :updated_at], methods: [:like_count, :like_by],current_user: @current_user)
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
        render json: "You are not authorized to update this kitten", status: :bad_request
      end
    else
      render json: "Kitten Does not exists", status: :bad_request
    end
  end

  def upvote
    @kitten = Kitten.find(params[:id])
    if @current_user.voted_as_when_voted_for @kitten
      render json: {status: "You have alerady liked this kitten"},status: :bad_request
    else
      @kitten.liked_by @current_user
      render json: {status: "kitten liked"}
    end
      rescue ActiveRecord::RecordNotFound => e
      render json: {
        error: e.to_s
      }, status: :not_found
  end

  def likers
    @kitten = Kitten.find(params[:id])
    render json: @kitten.as_json(only: [],methods:[:like_by])
  end


  def downvote
      @kitten = Kitten.find(params[:id])

      @kitten.disliked_by @current_user
      render json: {status: "kitten disliked"},status: :ok
       rescue ActiveRecord::RecordNotFound => e
      render json: {
      error: e.to_s
    }, status: :not_found
  end

  


  private

  def kitten_params
    params.require(:kitten).permit(:name, :age, :cuteness, :softness, :image)
  end
end


