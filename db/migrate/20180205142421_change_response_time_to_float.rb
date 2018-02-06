class ChangeResponseTimeToFloat < ActiveRecord::Migration[5.1]
  def change
    change_column :pings, :response_time, :float
  end
end
