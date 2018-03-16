class AddUserToTasks < ActiveRecord::Migration[5.0]
  def change
    add_column :tasks, :user_id, :string
  end
end
