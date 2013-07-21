class AddPhotoToItems < ActiveRecord::Migration
  def change
    add_column :items, :photo, :string, null: false, limit: 250, default: ''
  end
end
