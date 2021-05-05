class CreatePersonalData < ActiveRecord::Migration[5.2]
  def change
    create_table :personal_data do |t|
      t.string :name
      t.integer :lawful_basis

      t.timestamps
    end
  end
end
