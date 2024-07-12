# frozen_string_literal: true
class SubscriptionEvent < ApplicationRecord
  belongs_to :user
  belongs_to :event

  validates :payment_type, presence: true

  private

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "event_id", "id", "payment_status", "payment_type", "updated_at", "user_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["event", "user"]
  end
end