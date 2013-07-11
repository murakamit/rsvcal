class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string   :name,         null: false, limit:  50
      t.string   :memo,         null: false, limit: 250, default: ''
      t.datetime :removed_at,   null: false, default: "1900-01-01"
      t.integer  :lock_version, null: false, default: 0
      t.timestamps
    end
    # add_index :groups, :name, unique: true
  end
end
