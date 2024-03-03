class AddPaidToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :paid, :boolean
  end
end
