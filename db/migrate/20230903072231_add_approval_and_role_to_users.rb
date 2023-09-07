class AddApprovalAndRoleToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :is_approved, :boolean, default: false
    add_column :users, :role, :boolean, default: false
  end
end
