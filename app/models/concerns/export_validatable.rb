module ExportValidatable
  extend ActiveSupport::Concern

  included do
    validates :name, presence: { message: I18n.t("validations.export.must_have_name") }
    validates :status, presence: true

    validate :should_have_url_only_when_export_is_done
  end

  def should_have_url_only_when_export_is_done
    errors.add(:url, I18n.t("validations.export.url_only_when_export_is_done")) if status&.to_sym != :done && !url.nil?
  end
end
