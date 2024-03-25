class AddPaymentStatusToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :payment_status, :string
  end
end
