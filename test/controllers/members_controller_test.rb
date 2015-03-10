require 'test_helper'

class MembersControllerTest < ActionController::TestCase
  setup do
    @user = create(:user)
    @organization = create(:organization, members_attributes: [user: @user, role: :owner])
    sign_in_user
  end

  test 'should get request' do
    get :requests, organization_id: @organization.id
    assert_response :success
  end

  test 'should create member' do
    assert_difference 'Member.count', +1 do
      post :requests_complete, organization_id: @organization.id
    end

    assert_redirected_to organization_members_url(@organization)
  end

  test 'should sent mail to request' do
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      post :requests_complete, organization_id: @organization.id
    end

    request_email = ActionMailer::Base.deliveries.last
    assert_equal @organization.email, request_email.to.first
    assert_match @controller.current_user.name, request_email.body.to_s
  end
end
