# frozen_string_literal: true

class Event < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :subscription_events
  has_many :users, through: :subscription_events

  private

  def self.ransackable_attributes(auth_object = nil)
    ["announcer", "created_at", "description", "duration", "end_event_day", "id", "name", "open_subscription", "slug", "start_event_day", "updated_at", "value"]
  end
end
