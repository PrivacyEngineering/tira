class AddPurposeAndUtilizerParents < ActiveRecord::Migration[5.2]
  def change
    add_column :utilizers, :parent_utilizer, :string
  end
end
