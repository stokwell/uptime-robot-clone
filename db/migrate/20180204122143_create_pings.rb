class CreatePings < ActiveRecord::Migration[5.1]
  def change
    create_table :pings do |t|
      t.references :site, foreign_key: true
      t.string :response_status_code
      t.datetime :performed_at

      t.timestamps
    end
  end
end
