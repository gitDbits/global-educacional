class AddComplementAddressToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :complement_address, :string
  end
end
