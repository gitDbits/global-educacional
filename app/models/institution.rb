class Institution < ApplicationRecord

  private

  def self.ransackable_attributes(auth_object = nil)
    ["abbreviation", "address", "city", "cnpj", "complement", "created_at", "district", "email", "fantasy_name", "id", "name", "number_addres", "phone", "state", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
