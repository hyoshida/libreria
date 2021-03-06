require 'test_helper'

class OrganizationsControllerTest < ActionController::TestCase
  setup do
    @organization = create(:organization)
    sign_in_user @organization.owners.first
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:organizations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create organization" do
    assert_difference('Organization.count') do
      post :create, organization: attributes_for(:organization)
    end

    assert_redirected_to organization_path(assigns(:organization))
  end

  test "should show organization" do
    get :show, path: @organization
    assert_response :success
  end

  test "should get edit" do
    get :edit, path: @organization
    assert_response :success
  end

  test "should update organization" do
    new_name = "New #{@organization.name}"
    patch :update, path: @organization, organization: { name: new_name }
    assert_redirected_to organization_path(assigns(:organization))
  end

  test "should destroy organization" do
    assert_difference('Organization.count', -1) do
      delete :destroy, path: @organization
    end

    assert_redirected_to organizations_path
  end
end
