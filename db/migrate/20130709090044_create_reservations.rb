class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.integer  :item_id, null: false
      t.string   :user,    null: false, limit: 50
      t.date     :date,    null: false
      t.integer  :begin_h, null: false
      t.integer  :begin_m, null: false
      t.integer  :end_h,   null: false
      t.integer  :end_m,   null: false
      t.string   :icon,    null: false, limit:  50, default: '&#9734;'
      t.string   :memo,    null: false, limit: 250, default: ''
      t.datetime :removed_at,   null: false, default: '1900-01-01'
      t.integer  :lock_version, null: false, default: 0
      t.timestamps
    end
  end
end
