class AddAdminRoleToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :admin,:boolean, defalut: false
  end
end
