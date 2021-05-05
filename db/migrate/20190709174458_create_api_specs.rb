class CreateApiSpecs < ActiveRecord::Migration[5.2]
  def change
    create_table :api_specs do |t|
      t.jsonb :spec
      t.integer :service_id

      t.timestamps
    end
  end
end
