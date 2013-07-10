class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string   :name,         :null => false, :limit =>  50, :unique => true
      t.string   :password_digest, :null => false
      t.string   :memo,         :null => false, :limit => 250, :default => ''
      t.boolean  :admin,        :null => false, :default => false
      t.datetime :removed_at,   :null => false, :default => "1900-01-01"
      t.integer  :lock_version, :null => false, :default => 0
      t.timestamps
    end
  end
end
