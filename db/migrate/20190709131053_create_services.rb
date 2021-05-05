class CreateServices < ActiveRecord::Migration[5.2]
  def change
    create_table :services do |t|
      t.string :name
      t.string :gitlab_repo
      t.boolean :internal
      t.integer :service_provider_id

      t.timestamps
    end
  end
end
