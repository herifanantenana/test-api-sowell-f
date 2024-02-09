module VisitValidatable
  extend ActiveSupport::Concern

  included do
    validate :should_have_only_one_of_place_or_residence_or_spot
    validate :multiple_location_one_already_set
    validate :depth_level_of_base_location_type_relative_should_correspond_one_of_place_or_residence_or_spot_respectively
  end

  private

  def set_hash_residence_and_place_and_spot
    {residence: residence, place: place, spot: spot}
  end

  def get_class_name_snake_case
    self.class.to_s.gsub(/([a-z])([A-Z])/, '\1_\2').downcase
  end

  def get_the_path_for_depth_level_of_base_location_type
    return checklist&.location_type&.base_location_type&.depth_level if self.is_a?(VisitSchedule)
    return checkpoint&.checklist&.location_type&.base_location_type&.depth_level if self.is_a?(VisitProp)
  end

  def should_have_only_one_of_place_or_residence_or_spot
    location = set_hash_residence_and_place_and_spot
    if location.values.all?(&:present?) || location.values.none?(&:present?)
      errors.add(:base, I18n.t("validations.#{get_class_name_snake_case}.should_have_only_one_of_place_or_residence_or_spot"))
    end
  end

  def multiple_location_one_already_set
    location = set_hash_residence_and_place_and_spot
    if location.compact!&.size == 2
      location.each do |symbol_location, value_location|
        error_message = "validations.#{get_class_name_snake_case}.multiple_location_one_already_set"
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
      if existing_of.nil? || get_the_path_for_depth_level_of_base_location_type&.downcase != existing_of.class.name.downcase
        [:place, :residence, :spot].each do |symbol_location|
          error_message = I18n.t("validations.#{get_class_name_snake_case}.depth_level_of_base_location_type_relative_should_correspond.#{symbol_location.to_s}")
          errors.add(symbol_location, error_message) if existing_of.class.name.downcase == symbol_location.to_s
        end
      end
    end
  end
end
