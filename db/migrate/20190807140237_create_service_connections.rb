class CreateServiceConnections < ActiveRecord::Migration[5.2]
  def change
    create_table :service_connections do |t|
      t.integer :sender_id
      t.integer :service_id
      t.integer :direction, default: 0

      t.timestamps
    end
  end
end
