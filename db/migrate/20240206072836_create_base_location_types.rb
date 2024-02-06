class CreateBaseLocationTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :base_location_types do |t|
      t.string :name
      t.integer :depth_level

      t.timestamps
    end
  end
end
