class AddPaymentStatusToSubscriptionEvent < ActiveRecord::Migration[7.0]
  def change
    add_column :subscription_events, :payment_status, :string
  end
end
