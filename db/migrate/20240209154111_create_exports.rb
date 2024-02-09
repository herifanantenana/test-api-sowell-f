class CreateExports < ActiveRecord::Migration[7.0]
  def change
    create_table :exports do |t|
      t.string :name
      t.integer :status
      t.string :url
      t.jsonb :params
      t.references :author, foreign_key: { to_table: :users }, index: true

      t.timestamps
    end
  end
end
