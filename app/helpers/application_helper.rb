# frozen_string_literal: true

# ApplicationHelper
module ApplicationHelper
  def mask_money(value)
    "R$ #{number_to_currency(value, unit: '', separator: ',', delimiter: '.')}"
  end
end
