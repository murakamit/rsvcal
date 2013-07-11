class CreateWeeklies < ActiveRecord::Migration
  def change
    create_table :weeklies do |t|
      t.integer  :item_id, null: false
      t.string   :user,    null: false, limit: 50
      t.date  :date_begin, null: false
      t.date  :date_end,   null: false
      t.integer  :begin_h, null: false
      t.integer  :begin_m, null: false
      t.integer  :end_h,   null: false
      t.integer  :end_m,   null: false
      t.string   :icon,    null: false, limit: 50, default: '&#9834;'
      t.string   :memo,    null: false, limit: 50, default: ''
      t.datetime :removed_at,   null: false, default: '1900-01-01'
      t.integer  :lock_version, null: false, default: 0
      t.timestamps
    end
  end
end
