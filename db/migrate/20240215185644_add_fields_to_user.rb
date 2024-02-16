class AddFieldsToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :name, :string
    add_column :users, :cpf, :string
    add_column :users, :phone, :string
    add_column :users, :zipcode, :string
    add_column :users, :address, :string
    add_column :users, :number_address, :string
    add_column :users, :district, :string
    add_column :users, :city, :string
    add_column :users, :state, :string
  end
end
