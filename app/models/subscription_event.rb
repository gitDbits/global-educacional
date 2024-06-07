# frozen_string_literal: true
class SubscriptionEvent < ApplicationRecord
  belongs_to :user
  belongs_to :event

  validates :payment_type, presence: true

  enum payment_status: { paid: 'Pago', document_paid: 'Empenhado', document_bonus: 'Bônus' }
end