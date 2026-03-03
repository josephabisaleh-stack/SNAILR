class CreateSteps < ActiveRecord::Migration[8.1]
  def change
    create_table :steps do |t|
      t.string :title
      t.boolean :done, default: false
      t.integer :xp_reward
      t.integer :position, default: 1
      t.references :objective, null: false, foreign_key: true

      t.timestamps
    end
  end
end
