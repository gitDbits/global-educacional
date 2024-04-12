class CreateInstitutions < ActiveRecord::Migration[7.0]
  def change
    create_table :institutions do |t|
      t.string :name
      t.string :email
      t.string :fantasy_name
      t.string :abbreviation
      t.string :cnpj
      t.string :phone
      t.string :address
      t.string :number_addres
      t.string :district
      t.string :city
      t.string :state
      t.string :complement

      t.timestamps
    end
  end
end
