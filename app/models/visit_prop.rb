class VisitProp < ApplicationRecord
  include VisitValidatable

  belongs_to :checkpoint
  belongs_to :residence, optional: true
  belongs_to :spot, optional: true
  belongs_to :place, optional: true

end
