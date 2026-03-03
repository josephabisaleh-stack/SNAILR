class ChangeDefaultTotalXpForUsers < ActiveRecord::Migration[8.1]
  def change
    change_column_default :users, :total_xp, from: nil, to: 0
  end
end
