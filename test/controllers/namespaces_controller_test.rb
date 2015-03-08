require 'test_helper'

class NamespacesControllerTest < ActionController::TestCase
  test 'should show namespace with organization' do
    namespace = create(:namespace, :with_organization)
    get :show, path: namespace.path
    assert_redirected_to organization_path(namespace.ownerable)
  end

  test 'should show namespace with user' do
    namespace = create(:namespace, :with_user)
    get :show, path: namespace.path
    assert_redirected_to root_path
  end
end
