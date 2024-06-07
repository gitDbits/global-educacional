# frozen_string_literal: true

class AddAnnouncerToEvent < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :announcer, :string
  end
end
