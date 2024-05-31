class ExportResource < ApplicationResource
  attribute :name, :string
  attribute :status, :string_enum, allow: Export.status.keys
  attribute :url, :string
  attribute :params, :array
  attribute :author_id, :integer

  belogns_to :author, resources: UserResource

  before_create do |model|
    model.author_id = current_user.id
    model.status = 0
    model.url = nil
  end

end
