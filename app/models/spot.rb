class Spot < ApplicationRecord
  include SpotValidatable
  include SpotObserver

  belongs_to :place
  belongs_to :location_type

  has_many :visit_schedules, dependent: :destroy
  has_many :visit_props, dependent: :destroy
end
