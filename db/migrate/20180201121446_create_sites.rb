class CreateSites < ActiveRecord::Migration[5.1]
  def change
    create_table :sites do |t|
      t.string :title
      t.string :url
      t.integer :frequency
      t.boolean :enabled, default: true
      t.boolean :up
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
