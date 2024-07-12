# frozen_string_literal: true

class AddPaidNoteToSubscriptionEvent < ActiveRecord::Migration[7.0]
  def change
    add_column :subscription_events, :paid_note, :text
  end
end
