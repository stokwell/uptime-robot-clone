class AddCheckedAtToSite < ActiveRecord::Migration[5.1]
  def change
    add_column :sites, :checked_at, :datetime
  end
end
