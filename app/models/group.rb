# coding: utf-8

class Group < ActiveRecord::Base
  has_one :room

  before_validation :replace_nil_to_empty_at_memo, on: :create

  validates :name, presence: true
  validates :name, length: { in: 1 .. 50 }
  validates :name, format: { without: /\A(\s|　)+\Z/ }

  validates :memo, length: { maximum: 250 }

  def self.valid_ids
    # pending
  end

  def remove
    # pending
  end

  def replace_nil_to_empty_at_memo
    self.memo = '' if self.memo.nil?
  end
end
