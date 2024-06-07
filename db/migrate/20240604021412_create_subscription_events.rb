class CreateSubscriptionEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :subscription_events do |t|
      t.references :user, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.string :payment_type

      t.timestamps
    end
  end
end
