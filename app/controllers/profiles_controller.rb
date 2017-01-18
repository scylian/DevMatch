class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :only_current_user
  
  # GET to /users/:user_id/profile/new
  def new
    # Render blank profile details form
    @profile = Profile.new
  end
  
  # POST to /users/:user_id/profile
  def create
    @user = User.find( params[:user_id] )          # Ensure that we have the user who is filling out form
    @profile = @user.build_profile(profile_params) # Create profile linked to this specific user
    if @profile.save
      flash[:notice] = "Profile updated!"
      redirect_to user_path( id: params[:user_id] )
    else
      flash[:notice] = "Error occured while creating profile."
      render action: :new
    end
  end
  
  # GET to /users/:user_id/profile/edit
  def edit
    @user = User.find( params[:user_id] )
    @profile = @user.profile
  end
  
  # PATCH/PUT to /users/:user_id/profile
  def update
    @user = User.find( params[:user_id] )         # Retrieve the user from the database
    @profile = @user.profile                      # Retrieve that user's profile
    if @profile.update_attributes(profile_params) # Mass assign edited profile attributes and save (update)
      flash[:notice] = "Profile updated!"
      redirect_to user_path( id: params[:user_id])     # Redirect user to their profile page
    else
      flash[:notice] = "Error occurred while updating profile."
      render action: :edit
    end
  end
  
  private
    def profile_params
      params.require(:profile).permit(:first_name, :last_name, :avatar, :job_title, :phone_number, :contact_email, :description)
    end
    
    def only_current_user
      @user = User.find(params[:user_id])
      redirect_to root_url unless @user == current_user
    end

end