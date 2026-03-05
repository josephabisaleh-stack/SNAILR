class AddDetailsToSteps < ActiveRecord::Migration[8.1]
  def change
    add_column :steps, :goal, :text
    add_column :steps, :obstacle, :text
    add_column :steps, :quick_fix, :text
  end
end
