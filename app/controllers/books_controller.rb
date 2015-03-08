class BooksController < ApplicationController
  include BooksHelper

  before_action :authenticate_user!
  before_action :set_namespace
  before_action :authenticate_user_for_namespace!
  before_action :set_book, only: [:show, :edit, :update, :destroy]

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
    @book = Book.new(book_params)
    @book.namespace = @namespace
    @book.associate_amazon_item_by(params[:asin])

    if @book.save
      redirect_to @book, notice: 'Book was successfully created.'
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

  private

  def set_namespace
    @namespace = Namespace.find_by!(path: params[:namespace_path])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_book
    @book = Book.find_by(id: params[:id], namespace: @namespace)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def book_params
    params.fetch(:book, {}).permit(
      :location_name
    )
  end

  def authenticate_user_for_namespace!
   return if action_name.in?(['index', 'show']) && @namespace.ownerable.is_a?(Organization) && @namespace.ownerable.published
   return if @namespace.owners.include? current_user
   redirect_to root_path, alert: 'Access is not allowed'
  end
end
