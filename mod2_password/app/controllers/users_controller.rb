class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user1 = User.find(params[:id])
    # add_friend
    my_friends
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to login_path, notice: 'User was successfully created.' }
        format.json { render login_path, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def add_friend
    @user_event = UserEvent.create(user_id: params[:user_id], follower: params[:follower])
    redirect_to "/users/#{@user_event.follower}"
  end

  def my_friends
    @users = User.all

    @user_event = UserEvent.select{|ue| ue.user_id == current_user.id}
    @follower_ids = @user_event.map{|ue| ue.follower}

    @follower_event = UserEvent.select{|ue| ue.follower == current_user.id}
    @user_ids = @follower_event.map{|ue| ue.user_id}

  end

  def unfollow
      @user = User.find(params[:id])
      UserEvent.select do |user|
        if user.follower == @user.id
          user.destroy
        end
      end
      redirect_to @user
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :age, :description, :from, :duration, :email, :password, :password_confirmation, :profile_pic, :zip)
    end
