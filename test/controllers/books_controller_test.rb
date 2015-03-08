require 'test_helper'

class BooksControllerTest < ActionController::TestCase
  setup do
    @namespace = create(:namespace, :with_organization)
    @book = create(:book, namespace: @namespace)
  end

  test "should get index" do
    get :index, namespace_path: @namespace.path
    assert_response :success
    assert_not_nil assigns(:books)
  end

  test "should get new" do
    get :new, namespace_path: @namespace.path
    assert_response :success
  end

  test "should create book" do
    assert_difference('Book.count') do
      post :create, namespace_path: @namespace.path, book: attributes_for(:book)
    end

    assert_redirected_to namespace_book_path(assigns(:book), namespace_path: @namespace.path)
  end

  test "should show book" do
    get :show, namespace_path: @namespace.path, id: @book
    assert_response :success
  end

  test "should get edit" do
    get :edit, namespace_path: @namespace.path, id: @book
    assert_response :success
  end

  test "should update book" do
    patch :update, namespace_path: @namespace.path, id: @book, book: { location_name: 'New Location' }
    assert_redirected_to namespace_book_path(assigns(:book), namespace_path: @namespace.path)
  end

  test "should destroy book" do
    assert_difference('Book.count', -1) do
      delete :destroy, namespace_path: @namespace.path, id: @book
    end

    assert_redirected_to namespace_books_path(namespace_path: @namespace.path)
  end
end
