class CreatePings < ActiveRecord::Migration[5.1]
  def change
    create_table :pings do |t|
      t.datetime, :startet_add
      t.boolean, :success, default: false
      t.integer, :status_code
      t.references :site, foreign_key: true

      t.timestamps
    end
  end
end
