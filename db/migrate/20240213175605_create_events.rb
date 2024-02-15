# frozen_string_literal: true

# CreateEvents
class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :name
      t.string :duration
      t.float :value
      t.boolean :open_subscription

      t.timestamps
    end
  end
end
