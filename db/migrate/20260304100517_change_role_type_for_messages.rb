class ChangeRoleTypeForMessages < ActiveRecord::Migration[8.1]
  def change
    remove_column :messages, :role, :integer
    add_column :messages, :role, :string
  end
end
