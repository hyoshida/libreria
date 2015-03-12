class BooksController < ApplicationController
  include BooksHelper

  helper_method :namespace_owner?

  before_action :authenticate_user!
  before_action :set_namespace
  before_action :set_book, only: [:show, :edit, :update, :destroy, :loan]
  before_action :ensure_namespace_owner!, except: [:index, :show, :create, :loan]
  before_action :ensure_organization_member!, only: [:index, :show, :create, :loan]

  # GET /:namespace_path/books
  def index
    @books = Book.where(namespace: @namespace)
    begin
      @res = Amazon::Ecs.item_search(params[:q], response_group: 'Medium', country: 'jp', search_index: 'Books', power: 'binding:not kindle') if params[:q]
    rescue
      retry_count ||= 0
      retry_count += 1
      retry if retry_count <= 5
    end
  end

  # GET /:namespace_path/books/1
  def show
  end

  # GET /:namespace_path/books/new
  def new
    @book = Book.new
  end

  # GET /:namespace_path/books/1/edit
  def edit
  end

  # POST /:namespace_path/books
  def create
    @book = Book.new
    @book.namespace = @namespace
    @book.associate_amazon_item_by(params[:asin])

    if @book.save
      message = namespace_owner? ? 'Book was successfully created.' : 'Book was successfully wished.'
      redirect_to @book, notice: message
    else
      render :new
    end
  end

  # PATCH/PUT /:namespace_path/books/1
  def update
    if @book.update(book_params)
      redirect_to @book, notice: 'Book was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /:namespace_path/books/1
  def destroy
    @book.destroy
    redirect_to books_url, notice: 'Book was successfully destroyed.'
  end

  # PATCH/PUT /:namespace_path/books/1/loan
  def loan
    if @book.loaned
      redirect_to @book, notice: 'Book was successfully loaned.'
    else
      flash.now[:alert] = 'Book was not loaned.'
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
      :location_name
    )
  end

  def namespace_owner?
    @_namespace_owner ||= @namespace.owners.include? current_user
  end

  def ensure_namespace_owner!
   return if namespace_owner?
   redirect_to root_path, alert: 'Access denied.'
  end

  def ensure_organization_member!
   return unless @namespace.ownerable.is_a?(Organization)
   return if @namespace.ownerable.published?
   redirect_to root_path, alert: 'Access denied.'
  end
end
