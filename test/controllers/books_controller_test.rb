require 'test_helper'

class BooksControllerTest < ActionController::TestCase
  setup do
    @namespace = create(:namespace, :with_organization)
    @book = create(:book, namespace: @namespace)
    sign_in_user @namespace.owner
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
    amazon_item = create(:amazon_item)

    assert_difference('Book.count') do
      post :create, namespace_path: @namespace.path, book: attributes_for(:book), asin: amazon_item.asin
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

  test 'should wish book' do
    member = create(:user, namespace: @namespace)
    sign_in_user member

    assert_difference('Wish.count', +1) do
      patch :wish, namespace_path: @namespace.path, id: @book
    end

    assert_redirected_to namespace_book_path(assigns(:book), namespace_path: @namespace.path)
  end

  test 'should loan book' do
    other_user = create(:user, namespace: @namespace)
    sign_in_user other_user

    @book.arrived!

    assert_difference('Loan.unreturned.count', +1) do
      patch :loan, namespace_path: @namespace.path, id: @book
    end

    assert_redirected_to namespace_book_path(assigns(:book), namespace_path: @namespace.path)
  end

  test 'should return book' do
    other_user = create(:user, namespace: @namespace)
    sign_in_user other_user

    @book.arrived!
    @book.loans.build(user: other_user)
    @book.loaned!

    assert_difference('Loan.unreturned.count', -1) do
      patch :return, namespace_path: @namespace.path, id: @book
    end

    assert_redirected_to namespace_book_path(assigns(:book), namespace_path: @namespace.path)
  end
end
