class CreateObjectives < ActiveRecord::Migration[8.1]
  def change
    create_table :objectives do |t|
      t.string :title
      t.text :description
      t.string :status, default: "in_creation"
      t.integer :progress, default: 0
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
