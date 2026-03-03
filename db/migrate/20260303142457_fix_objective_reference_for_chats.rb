class FixObjectiveReferenceForChats < ActiveRecord::Migration[8.1]
  def change
    change_column_null :chats, :objective_id, true
  end
end
