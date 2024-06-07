class AddEventDayToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :event_day, :datetime
  end
end
