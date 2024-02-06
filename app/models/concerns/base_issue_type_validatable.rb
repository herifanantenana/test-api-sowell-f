module BaseIssueTypeValidatable
  extend ActiveSupport::Concern
  included do
    validates :name, presence: { message: I18n.t("validations.common.name_presence") }
    validates :base_location_type, presence: true
  end
end
