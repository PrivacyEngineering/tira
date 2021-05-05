class AddFieldsToUtilizer < ActiveRecord::Migration[5.2]
  def change
    add_column :utilizers, :email, :string
    add_column :utilizers, :city, :string
    add_column :utilizers, :plz, :string
    add_column :utilizers, :street, :string
    add_column :utilizers, :house_number, :string
    add_column :utilizers, :country, :string
    add_column :utilizers, :phone, :string
    add_column :utilizers, :fax, :string
    add_column :utilizers, :website, :string
    add_column :utilizers, :privacy_notice_url, :string
    add_column :utilizers, :open_api_names, :string, array: true

  end
end
