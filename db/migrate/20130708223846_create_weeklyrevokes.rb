class CreateWeeklyrevokes < ActiveRecord::Migration
  def change
    create_table :weeklyrevokes do |t|
      t.integer  :weekly_id,    :null => false
      t.string   :applicant,    :null => false, :limit =>  50
      t.date     :date,         :null => false
      t.string   :memo,         :null => false, :limit => 250, :default => ''
      t.datetime :removed_at,   :null => false, :default => '1900-01-01'
      t.integer  :lock_version, :null => false, :default => 0
      t.timestamps
    end
  end
end
