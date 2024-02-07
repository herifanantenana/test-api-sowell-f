class AddResidenceAndSpotToVisitSchedule < ActiveRecord::Migration[7.0]
  def change
    add_reference :visit_schedules, :residence, foreign_key: true
    add_reference :visit_schedules, :spot, foreign_key: true
  end
end
