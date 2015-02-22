class AddRegionToSummoners < ActiveRecord::Migration
  def change
    add_column :summoners, :region, :string
  end
end
