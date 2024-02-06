module LocationTypeValidatable
  extend ActiveSupport::Concern
  included do
    validates :company, presence: true
    validates :name, presence: { message: I18n.t("validations.common.name_presence") }
    validates :nature, presence: true
    validates :base_location_type, presence: true
  end
end
