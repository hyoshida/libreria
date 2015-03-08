class NamespacesController < ApplicationController
  # GET /:path
  def show
    namespace = Namespace.find_by!(path: params[:path])

    if namespace.ownerable.is_a? Organization
      redirect_to organization_path(namespace.ownerable)
    else
      # redirect_to user_path(namespace.ownerable)
      redirect_to root_path
    end
  end
end
