class BooksController < ApplicationController
  include BooksHelper

  helper_method :namespace_owner?

  ACTIONS_FOR_NON_OWNER = %i( index show new create wish loan return )

  before_action :authenticate_user!
  before_action :set_namespace
  before_action :set_book, only: [:show, :edit, :update, :destroy, :wish, :loan, :return]
  before_action :ensure_namespace_owner!, except: ACTIONS_FOR_NON_OWNER
  before_action :ensure_organization_member!, only: ACTIONS_FOR_NON_OWNER

  # GET /:namespace_path/books
  def index
    @books = Book.where(namespace: @namespace)
  end

  # GET /:namespace_path/books/1
  def show
  end

  # GET /:namespace_path/books/new
  def new
    @book = Book.new

    begin
      @amazon_response = Amazon::Ecs.item_search(params[:q], response_group: 'Medium', country: 'jp', search_index: 'Books', power: 'binding:not kindle') if params[:q]
    rescue
      retry_count ||= 0
      retry_count += 1
      retry if retry_count <= 5
    end
  end

  # GET /:namespace_path/books/1/edit
  def edit
  end

  # POST /:namespace_path/books
  def create
    @book = Book.new
    @book.namespace = @namespace
    @book.associate_amazon_item_by(params[:asin])
    @book.wishes.build(user: current_user)

    if @book.save
      message = namespace_owner? ? flash_message_for(@book, :successfully_created) : t(:book_was_successfully_wished)
      redirect_to @book, notice: message
    else
      render :new
    end
  end

  # PATCH/PUT /:namespace_path/books/1
  def update
    if @book.update(book_params)
      redirect_to @book, notice: flash_message_for(@book, :successfully_updated)
    else
      render :edit
    end
  end

  # DELETE /:namespace_path/books/1
  def destroy
    @book.destroy
    redirect_to books_url, notice: flash_message_for(@book, :successfully_destroyed)
  end

  # PATCH/PUT /:namespace_path/books/1/wish
  def wish
    if !@book.state?(:wished)
      flash.now[:alert] = t(:book_was_already_owned)
      return render :show
    end

    @book.wishes.build(user: current_user)

    if @book.save
      redirect_to @book, notice: t(:book_was_successfully_wished)
    else
      render :show
    end
  end

  # PATCH/PUT /:namespace_path/books/1/loan
  def loan
    @book.loans.build(user: current_user)

    if @book.loaned
      redirect_to @book, notice: t(:book_was_successfully_loaned)
    else
      render :show
    end
  end

  # PATCH/PUT /:namespace_path/books/1/return
  def return
    if @book.borrower != current_user
      flash.now[:alert] = t(:book_was_already_returned)
      return render :show
    end

    if @book.returned
      redirect_to @book, notice: t(:book_was_successfully_returned)
    else
      render :show
    end
  end

  private

  def set_namespace
    if params[:namespace_path]
      @namespace = Namespace.find_by!(path: params[:namespace_path])
    else
      @namespace = current_user.namespace
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_book
    @book = Book.find_by(id: params[:id], namespace: @namespace)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def book_params
    params.fetch(:book, {}).permit(
      :state_event,
      :state,
      :location_name,
      option_values_attributes: [:id, :option_type_id, :name]
    )
  end

  def namespace_owner?
    @_namespace_owner ||= @namespace.owners.include? current_user
  end

  def ensure_namespace_owner!
   return if namespace_owner?
   redirect_to_access_denied
  end

  def ensure_organization_member!
   return unless @namespace.ownerable.is_a?(Organization)
   return if @namespace.ownerable.published?
   redirect_to_access_denied
  end

  def redirect_to_access_denied
   redirect_to (@book ? @book : books_path), alert: t(:access_denied)
  end
end
