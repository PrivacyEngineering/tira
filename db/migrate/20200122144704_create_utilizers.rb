class CreateUtilizers < ActiveRecord::Migration[5.2]
  def change
    create_table :utilizers do |t|

      t.timestamps
    end
  end
end
