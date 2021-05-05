class IgnoreFieldToService < ActiveRecord::Migration[5.2]
  def change
    add_column :services, :ignore, :boolean
  end
end
