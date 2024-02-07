# frozen_string_literal: true

module IssueTypeValidatable
  extend ActiveSupport::Concern

  included do
    validates :name, presence: { message: I18n.t("validations.common.name_presence") }
    validate :base_location_type_should_be_the_same
    validate :location_type_should_belong_to_company
  end

  def location_type_should_belong_to_company
    if location_type&.company_id != company_id
      errors.add(:location_type,
                 I18n.t("validations.common.belonging_to_company"))
    end
  end

  def base_location_type_should_be_the_same
    if base_issue_type.nil? || location_type.nil? || base_issue_type.base_location_type != location_type.base_location_type
      errors.add(:base_location_type, I18n.t("validations.common.base_location_type_should_be_the_same"))
    end
  end
end
