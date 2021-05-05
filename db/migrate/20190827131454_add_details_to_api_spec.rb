class AddDetailsToApiSpec < ActiveRecord::Migration[5.2]
  def change
    add_column :api_specs, :branch, :string
    add_column :api_specs, :author, :string
    add_column :api_specs, :commit_url, :string
  end
end
