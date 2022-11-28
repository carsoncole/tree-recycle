class AddFacebookMetaToSettings < ActiveRecord::Migration[7.0]
  def change
    add_column :settings, :facebook_page_id, :string
    add_column :settings, :meta_site_name, :string
    add_column :settings, :meta_title, :string
    add_column :settings, :meta_description, :string
    add_column :settings, :meta_image_filename, :string
  end
end
