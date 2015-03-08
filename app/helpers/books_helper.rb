module BooksHelper
  def books_path(*args)
    add_namespace_path_to_options!(args)
    namespace_books_path(*args)
  end

  def new_book_path(*args)
    add_namespace_path_to_options!(args)
    new_namespace_book_path(*args)
  end

  def edit_book_path(*args)
    add_namespace_path_to_options!(args)
    edit_namespace_book_path(*args)
  end

  def book_path(*args)
    add_namespace_path_to_options!(args)
    namespace_book_path(*args)
  end

  def books_url(*args)
    add_namespace_path_to_options!(args)
    namespace_books_url(*args)
  end

  def book_url(*args)
    add_namespace_path_to_options!(args)
    namespace_book_url(*args)
  end

  private

  def add_namespace_path_to_options!(args)
    options = args.extract_options!
    args << options if options.empty?
    options[:namespace_path] = @namespace.path
  end
end
