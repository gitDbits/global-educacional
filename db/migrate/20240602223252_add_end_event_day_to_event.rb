class AddEndEventDayToEvent < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :end_event_day, :datetime
  end
end
