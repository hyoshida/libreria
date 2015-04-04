class OrganizationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_namespace, except: [:index, :new, :create]
  before_action :set_organization, only: [:show, :edit, :update, :destroy]
  before_action :ensure_organization_owner!, only: [:edit, :update, :destroy]

  # GET /organizations
  def index
    @organizations = Organization.all
  end

  # GET /organizations/1
  def show
  end

  # GET /organizations/new
  def new
    @organization = Organization.new
    @organization.build_namespace
  end

  # GET /organizations/1/edit
  def edit
  end

  # POST /organizations
  def create
    @organization = Organization.new(organization_params)
    @organization.members_attributes = [ user: current_user, role: :owner, activated: true ]

    if @organization.save
      redirect_to @organization, notice: flash_message_for(@organization, :successfully_created)
    else
      render :new
    end
  end

  # PATCH/PUT /organizations/1
  def update
    if @organization.update(organization_params)
      redirect_to @organization, notice: flash_message_for(@organization, :successfully_updated)
    else
      render :edit
    end
  end

  # DELETE /organizations/1
  def destroy
    @organization.destroy
    redirect_to organizations_url, notice: flash_message_for(@organization, :successfully_destroyed)
  end

  private

  def set_namespace
    @namespace = Namespace.includes(ownerable: { members: { user: :namespace } }).find_by!(path: params[:path])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_organization
    @organization = @namespace.ownerable
  end

  def organization_params
    params.require(:organization).permit(
      :name,
      :published,
      namespace_attributes: [:id, :path, option_types_attributes: [:id, :_destroy, :name]]
    )
  end

  def ensure_organization_owner!
    return if @organization.owners.include? current_user
    redirect_to root_path, alert: t(:access_denied)
  end
end
