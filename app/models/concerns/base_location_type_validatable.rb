module  BaseLocationTypeValidatable
  extend ActiveSupport::Concern
  included do
    validates :name, presence: true, length: { minimum: 1 }
    validates :depth_level, presence: true
  end
end
