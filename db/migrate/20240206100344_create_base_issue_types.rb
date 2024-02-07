class CreateBaseIssueTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :base_issue_types do |t|
      t.string :name
      t.references :base_location_type, null: false, foreign_key: true

      t.timestamps
    end
  end
end
