# coding: utf-8

class Item < ActiveRecord::Base
  belongs_to :group
  include Paranoid

  # --- --- --- --- --- --- --- --- --- --- --- ---
  before_validation :replace_nil_to_empty_at_memo, on: :create

  validates :group_id, presence: true

  validates :name, presence: true
  validates :name, length: { in: 1 .. 50 }
  validates :name, format: { without: /\A(\s|　)+\Z/ }

  validates :memo, length: { maximum: 250 }

  # --- --- --- --- --- --- --- --- --- --- --- ---
  def remove
    # pending
  end

  def replace_nil_to_empty_at_memo
    self.memo = '' if self.memo.nil?
  end
end
