require 'test_helper'

class NamespacesControllerTest < ActionController::TestCase
  test 'should show namespace with organization' do
    organization = create(:organization)
    namespace = organization.namespace
    get :show, path: namespace.path
    assert_redirected_to organization_path(organization)
  end

  test 'should show namespace with user' do
    user = create(:user)
    namespace = user.namespace
    get :show, path: namespace.path
    assert_redirected_to root_path
  end
end
