class AddUrlToAttributeName < ActiveRecord::Migration[5.2]
  def change
    rename_column :services, :gitlab_repo, :gitlab_repo_url
  end
end
