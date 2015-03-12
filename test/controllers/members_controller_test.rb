require 'test_helper'

class MembersControllerTest < ActionController::TestCase
  setup do
    @owner = create(:user)
    @organization = create(:organization, members_attributes: [user: @owner, role: :owner, activated: true])
    sign_in_user
  end

  test 'should get request' do
    get :requests, organization_id: @organization.id
    assert_response :success
  end

  test 'should create inactivated member' do
    assert_difference 'Member.inactivated.count', +1 do
      post :requests_complete, organization_id: @organization.id
    end

    assert_redirected_to organization_url(@organization)
  end

  test 'should sent mail to request' do
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      post :requests_complete, organization_id: @organization.id
    end

    request_email = ActionMailer::Base.deliveries.last
    assert_equal @organization.email, request_email.to.first
    assert_match @controller.current_user.name, request_email.body.to_s
  end

  test 'should update to activated member' do
    sign_in_user @owner
    other_user = create(:user)
    requested_member = request_by(other_user)

    assert_difference 'Member.count', +1 do
      get :accept, organization_id: @organization.id, request_token: requested_member.request_token
    end

    assert_redirected_to organization_members_url(@organization)
  end

  test 'should sent mail to notice of acception' do
    sign_in_user @owner
    other_user = create(:user)
    requested_member = request_by(other_user)

    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      get :accept, organization_id: @organization.id, request_token: requested_member.request_token
    end

    request_email = ActionMailer::Base.deliveries.last
    assert_equal requested_member.email, request_email.to.first
    assert_match @organization.name, request_email.body.to_s
  end

  private

  def request_by(user)
    member = @organization.members.inactivated.build(user: user)
    member.generate_request_token
    member.save!
    member
  end
end
