# frozen_string_literal: true

# ApplicationHelper
module ApplicationHelper
  include Pagy::Frontend

  def bootstrap_class_for_flash(flash_type)
    case flash_type.to_sym
    when :notice
      'alert-success'
    when :alert
      'alert-warning'
    when :error
      'alert-danger'
    else
      flash_type.to_s
    end
  end

  def mask_money(value)
    "R$ #{number_to_currency(value, unit: '', separator: ',', delimiter: '.')}"
  end

  def mask_cpf(value)
    return unless value

    "#{value[0, 3]}.#{value[3, 3]}.#{value[6, 3]}-#{value[9, 2]}"
  end

  def mask_cnpj(value)
    return unless value

    "#{value[0, 2]}.#{value[2, 3]}.#{value[5, 3]}/#{value[8, 4]}-#{value[12, 2]}"
  end

  def mask_zipcode(value)
    return unless value

    "#{value[0, 2]}.#{value[2, 3]}-#{value[5, 3]}"
  end

  def mask_phone(value)
    return unless value

    if value && value.length > 10
      "(#{value[0, 2]}) #{value[2, 1]} #{value[3, 4]}-#{value[7, 4]}"
    elsif value
      "(#{value[0, 2]}) #{value[2, 4]}-#{value[5, 4]}"
    end
  end

  def full_address(user)
    zipcode = user.zipcode
    address = user.address
    number_address = user.number_address
    district = user.district
    city = user.city
    state = user.state
    complement = user.complement_address

    "#{zipcode} - #{address}, #{number_address} - #{district} - #{city}/#{state} - #{complement}"
  end
end
