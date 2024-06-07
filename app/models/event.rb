# frozen_string_literal: true

class Event < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :subscription_events
  has_many :users, through: :subscription_events
end
