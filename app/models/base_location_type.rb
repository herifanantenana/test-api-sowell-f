class BaseLocationType < ApplicationRecord
  include BaseLocationTypeValidatable

  has_many :location_types, dependent: :destroy
  has_many :base_issues_types

  enum :depth_level, { residence: 1, place: 2, spot: 3 }
end
