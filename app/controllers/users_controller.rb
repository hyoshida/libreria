class UsersController < ApplicationController
  before_action :set_namespace, only: :show
  before_action :set_user, only: :show

  # GET /users.json
  def index
    @users = User.where('email LIKE ?', "%#{params[:q]}%")

    respond_to do |format|
      format.json { render json: @users }
    end
  end

  # GET /users/:namespace_path
  def show
  end

  private

  def set_namespace
    @namespace = Namespace.find_by!(path: params[:path])
  end

  def set_user
    @user = @namespace.ownerable
  end
end
