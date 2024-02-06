class BaseLocationType < ApplicationRecord

  has_many :location_types, dependent: :destroy

  validates :name, presence: true, length: { minimum: 1 }
  enum depth_level: { residence: 1, place: 2, spot: 3 }, validate: true

end
