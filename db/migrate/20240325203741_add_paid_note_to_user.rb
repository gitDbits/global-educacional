class AddPaidNoteToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :paid_note, :text
  end
end
