module ExportValidatable
  extend ActiveSupport::Concern

  included do
    validates :name, presence: { message: I18n.t("validations.export.must_have_name") }
    validates :status, presence: true

    validate :should_have_url_only_when_export_is_done
    validate :name_should_correspond_to_data_model_in_params
  end

  def should_have_url_only_when_export_is_done
    errors.add(:url, I18n.t("validations.export.url_only_when_export_is_done")) if status&.to_sym != :done && !url.nil?
  end

  def name_should_correspond_to_data_model_in_params
    # recuperation de tout les cle du json dans params
    export_data_model = {
      "checklist": Checklist,
      "checkpoint": Checkpoint,
      "issue report": IssueReport,
      "issue type": IssueType,
      "location type": LocationType,
      "visit report": VisitReport,
      "visit schedule": VisitSchedule,
      "company": Company
    }

    model_name_params = nil
    export_data_model.each do |key, value|
      if name.downcase.end_with?(key.to_s)
        model_name_params = value.new
        break
      end
    end

    return errors.add(:name, I18n.t("validations.export.name_should_correspond_to_data_model_in_params")) if model_name_params.nil?

    unless params.keys.map(&:to_s).all? { |key| model_name_params.attribute_names.include?(key) }
      # model_name_params.attribute_name&.any? { |attribute| /\A#{Regexp.escape(key)}/.match?(attribute) }
      errors.add(:params, I18n.t("validations.export.data_model_in_params_should_correspond_to_model_name"))
    end
  end
end
