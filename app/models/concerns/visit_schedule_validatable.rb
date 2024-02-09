module VisitScheduleValidatable
  extend ActiveSupport::Concern

  included do
    validates :due_at, presence: true, if: -> { checklist&.is_planned }
    validates :due_at, absence: true, unless: -> { checklist&.is_planned }
    validate :cant_set_invalid_due_at, on: :update, unless: -> { skip_due_at_validation || !checklist&.is_planned }
    validate :cant_set_incompatible_place_and_checklist
=begin
    validate :should_have_only_one_of_place_or_residence_or_spot
    validate :multiple_location_one_already_set
    validate :depth_level_of_base_location_type_relative_should_correspond_one_of_place_or_residence_or_spot_respectively
=end
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
=begin
  def set_hash_residence_and_place_and_spot
    {residence: residence, place: place, spot: spot}
  end

  def should_have_only_one_of_place_or_residence_or_spot
    location = set_hash_residence_and_place_and_spot
    if location.values.all?(&:present?) || location.values.none?(&:present?)
      errors.add(:base, I18n.t("validations.visit_schedule.should_have_only_one_of_place_or_residence_or_spot"))
    end
  end

  def multiple_location_one_already_set
    location = set_hash_residence_and_place_and_spot
    if location.compact!&.size == 2
      location.each do |symbol_location, value_location|
        error_message = "validations.visit_schedule.multiple_location_one_already_set"
        location.each do |symbol, value|
          error_message << ".#{symbol.to_s}" if symbol != symbol_location
        end
        errors.add(symbol_location, I18n.t(error_message))
      end
    end
  end

  def depth_level_of_base_location_type_relative_should_correspond_one_of_place_or_residence_or_spot_respectively
    if [residence, place, spot].compact.size == 1
      existing_of = place || residence || spot
      if existing_of.nil? || checklist&.location_type&.base_location_type&.depth_level.downcase != existing_of.class.name.downcase
        [:place, :residence, :spot].each do |symbol_location|
          error_message = I18n.t("validations.visit_schedule.depth_level_of_base_location_type_relative_should_correspond.#{symbol_location.to_s}")
          errors.add(symbol_location, error_message) if existing_of.class.name.downcase == symbol_location.to_s
        end
      end
    end
  end
=end
end
