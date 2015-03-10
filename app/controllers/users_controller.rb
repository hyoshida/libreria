class UsersController < ApplicationController
  # GET /users.json
  def index
    @users = User.where('email LIKE ?', "%#{params[:q]}%")

    respond_to do |format|
      format.json { render json: @users }
    end
  end
end
