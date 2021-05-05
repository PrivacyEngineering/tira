class AddGitHttpUrlToService < ActiveRecord::Migration[5.2]
  def change
    add_column :services, :git_http_url, :string
  end
end
