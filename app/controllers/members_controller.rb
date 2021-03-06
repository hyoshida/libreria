class MembersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_namespace
  before_action :set_organization
  before_action :ensure_organization_owner!, except: [:requests, :requests_complete]
  before_action :ensure_published!, only: [:request, :request_complete]

  # GET /organizations/:organization_id/members
  def index
    @members = @organization.members
  end

  # GET /organizations/:organization_id/members/new
  def new
    @member = @organization.members.build
  end

  # POST /organizations/:organization_id/members
  def create
    @member = @organization.members.build(member_params)
    @member.activated = true

    if @member.save
      redirect_to organization_members_url(@organization), notice: flash_message_for(@member, :successfully_created)
    else
      render :new
    end
  end

  # PATCH/PUT /organizations/:organization_id/members
  def update
    if @organization.update(organization_params)
      redirect_to organization_members_url(@organization), notice: flash_message_for(@member, :successfully_updated)
    else
      render :index
    end
  end

  # GET /organizations/:organization_id/members/:id
  def destroy
    @member = @organization.members.find(params[:id])
    @member.destroy
    redirect_to organization_members_url(@organization), notice: flash_message_for(@member, :successfully_destroyed)
  end

  # GET /organizations/:organization_id/members/request
  def requests
    @member = @organization.members.inactivated.build(user: current_user)
  end

  # POST /organizations/:organization_id/members/request
  def requests_complete
    @member = @organization.members.inactivated.build(user: current_user)
    @member.generate_request_token
    @member.request_sent_at = Time.now

    if @member.save
      MemberMailer.requests(@organization, @member).deliver_now
      redirect_to organization_url(@organization), notice: t(:membership_was_successfully_requested)
    else
      render :requests
    end
  end

  # GET /organizations/:organization_id/members/accept?request_token=:request_token
  def accept
    member = @organization.members.inactivated.find_by!(request_token: params[:request_token])
    member.activated = true
    member.request_accepted_at = Time.now
    member.request_acceptor = current_user

    if member.save
      MemberMailer.accept(@organization, member).deliver_now
      redirect_to organization_members_url(@organization), notice: t(:membership_was_successfully_accepted)
    else
      redirect_to organization_members_url(@organization), alert: t(:token_is_broken)
    end
  end

  private

  def set_namespace
    @namespace = Namespace.includes(ownerable: { members: { user: :namespace } }).find_by!(path: params[:organization_path])
  end

  def set_organization
    @organization = @namespace.ownerable
  end

  def member_params
    params.require(:member).permit(
      :user_id,
      :role
    )
  end

  def organization_params
    params.require(:organization).permit(
      members_attributes: [:id, :user_id, :role]
    )
  end

  def ensure_organization_owner!
    return if @organization.owners.include? current_user
    redirect_to root_path, alert: t(:access_denied)
  end

  def ensure_published!
    return if @organization.published?
    redirect_to root_path, alert: t(:organization_is_unpublished)
  end
end
