class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.integer  :group_id,     :null => false
      t.string   :name,         :null => false, :limit =>  50
      t.string   :memo,         :null => false, :limit => 250, :default => ''
      t.datetime :deleted_at,   :null => false, :default => '1900-01-01'
      t.integer  :lock_version, :null => false, :default => 0
      t.timestamps
    end
  end
end
