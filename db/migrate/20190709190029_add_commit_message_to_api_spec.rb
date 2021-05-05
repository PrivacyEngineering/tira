class AddCommitMessageToApiSpec < ActiveRecord::Migration[5.2]
  def change
    add_column :api_specs, :description, :string
    add_column :api_specs, :commit_message, :string
  end
end
