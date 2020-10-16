class AddResponseTimeToPings < ActiveRecord::Migration[5.1]
  def change
    add_column :pings, :response_time, :integer
  end
end
