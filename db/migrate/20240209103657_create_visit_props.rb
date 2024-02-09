class CreateVisitProps < ActiveRecord::Migration[7.0]
  def change
    create_table :visit_props do |t|
      t.boolean :is_missing
      t.references :checkpoint, foreign_key: true, index: true
      t.references :residence, foreign_key: true, index: true
      t.references :spot, foreign_key: true, index: true
      t.references :place, foreign_key: true, index: true
      t.timestamps
    end
  end
end
