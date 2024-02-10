class ExportController < ApplicationController

  # GET /exports
  def index
    @exports = ExportResource.all(params)
    render jsonapi: @exports
  end

  # GET /exports/1
  def show
    Export.new.authorize_from_resource_proxy(:read, @export)
    render jsonapi: @export
  end

  # POST /exports
  def create
    @export = Export.new(export_params.merge({status: 0, url:nil, author: current_user}))
    if @export.save
      render jsonapi: @export, status: :created
    else
      render jsonapi: @export.errors, status: :unprocessable_entity
    end

  end

  private
  def export_params
    params.require(:export).permit(:name, :status, :url, :params, :author)
  end
end