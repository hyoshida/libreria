class MembersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_organization
  #before_action :authenticate_user_for_organization!, except: [:request, :request_complete]

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

    if @member.save
      redirect_to organization_members_url(@organization), notice: 'Member was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /organizations/:organization_id/members
  def update
    if @organization.update(organization_params)
      redirect_to organization_members_url(@organization), notice: 'Members was successfully updated.'
    else
      render :index
    end
  end

  # GET /organizations/:organization_id/members/:id
  def destroy
    @member = @organization.members.find(params[:id])
    @member.destroy
    redirect_to organization_members_url(@organization), notice: 'Member was successfully destroyed.'
  end

  # GET /organizations/:organization_id/members/request
  def requests
    @member = @organization.members.build(user: current_user)
  end

  # POST /organizations/:organization_id/members/request
  def requests_complete
    @member = @organization.members.build(user: current_user)
    @member.generate_request_token

    if @member.save
      MemberMailer.requests(@organization, @member).deliver_now
      redirect_to organization_members_url(@organization), notice: 'Member was successfully created.'
    else
      render :requests
    end
  end

  private

  def set_organization
    @organization = Organization.find(params[:organization_id])
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
end
