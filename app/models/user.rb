# frozen_string_literal: true

# User
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates_with EmailAddress::ActiveRecordValidator, field: :email, if: -> { email.present? }

  validate :validate_cpf, on: :create
  validate :validate_uniqueness_fields

  private

  def validate_cpf
    return if self.cpf.blank?

    cpf = CPF.new(self.cpf)

    unless cpf.valid?
      errors.add(:cpf, ": #{cpf.formatted} #{I18n.t('errors.messages.invalid')}")
    end

    self.cpf = cpf.stripped
  end

  def validate_uniqueness_fields
    %i[name phone cpf].each do |attribute|
      next if self[attribute].blank?

      value = self[attribute]
      value = value.gsub(/\D/, '') if attribute == :cpf

      if User.where(attribute => value).where.not(id: id).exists?
        errors.add(attribute, 'já está em uso')
      end
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[id name email cpf phone payment_method]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
