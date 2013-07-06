# coding: utf-8

class Group < ActiveRecord::Base
  has_one :room
  include Paranoid
  include Memoable

  # --- --- --- --- --- --- --- --- --- --- --- ---
  validates :name, presence: true
  validates :name, length: { in: 1 .. 50 }
  validates :name, format: { without: /\A(\s|　)+\Z/ }
end
