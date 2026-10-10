class AddDueDateToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :due_date, :date
  end
end
