class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string   :name,         :null => false, :limit =>  50
      t.string   :password_digest, :null => false
      t.string   :memo,         :null => false, :limit => 250, :default => ''
      t.boolean  :admin,        :null => false, :default => false
      t.integer  :lock_version, :null => false, :default => 0
      t.timestamps
    end
  end
end
