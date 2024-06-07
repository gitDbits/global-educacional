class RenameEventDayToEvent < ActiveRecord::Migration[7.0]
  def change
    rename_column :events, :event_day, :start_event_day
  end
end
