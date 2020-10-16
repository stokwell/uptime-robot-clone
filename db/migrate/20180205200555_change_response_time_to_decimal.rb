class ChangeResponseTimeToDecimal < ActiveRecord::Migration[5.1]
  def change
    change_column :pings, :response_time, 'decimal USING CAST(response_time AS decimal)'
  end
end
