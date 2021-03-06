class DogsController < ApplicationController
  before_action :set_dog, only: [:show, :edit, :update, :destroy, :like]
  # before_action :authenticate_user!

  # GET /dogs
  # GET /dogs.json
  def index
    if params[:sort]
      @dogs = Dog.where("updated_at > ?", 1.hour.ago).order(cached_votes_total: :desc).paginate(page: params[:page], per_page: 5)
    else
      @dogs = Dog.paginate(page: params[:page], per_page: 5)
    end
  end

  # GET /dogs/1
  # GET /dogs/1.json
  def show
  end

  # GET /dogs/new
  def new
    @dog = Dog.new
  end

  # GET /dogs/1/edit
  def edit
    unless @dog.user_id == current_user.id
      respond_to do |format|
        format.html { redirect_to dog_path, alert: "Not yo dog, dog." }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /dogs
  # POST /dogs.json
  def create
    @dog = Dog.new(dog_params)

    respond_to do |format|
      if @dog.save
        if params[:dog][:images].present?
          params[:dog][:images].each do |image|
            @dog.images.attach(image)
          end
        end

        format.html { redirect_to @dog, notice: 'Dog was successfully created.' }
        format.json { render :show, status: :created, location: @dog }
      else
        format.html { render :new }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dogs/1
  # PATCH/PUT /dogs/1.json
  def update
    respond_to do |format|
      if @dog.update(dog_params)
        if params[:dog][:images].present?
          params[:dog][:images].each do |image|
            @dog.images.attach(image)
          end
        end

        format.html { redirect_to @dog, notice: 'Dog was successfully updated.' }
        format.json { render :show, status: :ok, location: @dog }
      else
        format.html { render :edit }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dogs/1
  # DELETE /dogs/1.json
  def destroy
    @dog.destroy
    respond_to do |format|
      format.html { redirect_to dogs_url, notice: 'Dog was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def like
    if @dog.user_id == current_user.id
      respond_to do |format|
        # raise
        format.html { redirect_back fallback_location: dogs_url, alert: "Can't like your own dog." }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    else
      @dog.liked_by current_user
      @dog.touch #hack
      respond_to do |format|
        format.html { redirect_back fallback_location: dogs_url, notice: "That's a good dog." }
        format.json { render :show, status: :ok, location: @dog }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_dog
    @dog = Dog.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def dog_params
    params[:dog].merge!(:user_id => current_user.id)
    params.require(:dog).permit(:name, :description, :images, :user_id)
  end
end
