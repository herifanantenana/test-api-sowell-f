module VisitScheduleValidatable
  extend ActiveSupport::Concern

  included do
    validates :due_at, presence: true, if: -> { checklist&.is_planned }
    validates :due_at, absence: true, unless: -> { checklist&.is_planned }
    validate :cant_set_invalid_due_at, on: :update, unless: -> { skip_due_at_validation || !checklist&.is_planned }
    validate :cant_set_incompatible_place_and_checklist
  end

  private

  def cant_set_invalid_due_at
    errors.add(:due_at, I18n.t("validations.visit_schedule.invalide_due_at")) if due_at.nil? || due_at < DateTime.now
  end

  def cant_set_incompatible_place_and_checklist
    if !place.nil? && !checklist.nil? && (place.company_id != checklist.company_id)
      errors.add(:place, I18n.t("validations.visit_schedule.incompatible_place_and_checklist"))
    end
  end

  def should_not_have_place_and_residence_and_spot_at_the_same_record
    if !place.nil? && !residence.nil? && !spot.nil?
      errors.add(:place, I18n.t("validations.visit_schedule.should_not_have_place_and_residence_and_spot_at_the_same_record"))
      errors.add(:residence, I18n.t("validations.visit_schedule.should_not_have_place_and_residence_and_spot_at_the_same_record"))
      errors.add(:spot, I18n.t("validations.visit_schedule.should_not_have_place_and_residence_and_spot_at_the_same_record"))
    end
  end

  def should_have_only_one_of_place_or_residence_or_spot
    all_are_nil = place.nil? && residence.nil? && spot.nil?
    two_has_value = ( !place.nil? && !residence.nil? ) || ( !place.nil? && !spot.nil? ) || ( !residence.nil? && !spot.nil? )
    if all_are_nil || two_has_value
      errors.add(:place, I18n.t("validations.visit_schedule.should_have_only_one_of_place_or_residence_or_spot"))
      errors.add(:residence, I18n.t("validations.visit_schedule.should_have_only_one_of_place_or_residence_or_spot"))
      errors.add(:spot, I18n.t("validations.visit_schedule.should_have_only_one_of_place_or_residence_or_spot"))
    end
  end
end
