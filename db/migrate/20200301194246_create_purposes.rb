class CreatePurposes < ActiveRecord::Migration[5.2]
  def change
    create_table :purposes do |t|
      t.string :name
      t.string :parent_prupose

      t.timestamps
    end
  end
end
