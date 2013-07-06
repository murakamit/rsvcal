# coding: utf-8

class Group < ActiveRecord::Base
  has_one :room

  THRESHOLD_YEAR = 2000
  THRESHOLD_DAY = "#{THRESHOLD_YEAR}-1-1 00:00:00" # removed?

  scope :active_only,  -> { where("removed_at <  ?", THRESHOLD_DAY) }
  scope :removed_only, -> { where("removed_at >= ?", THRESHOLD_DAY) }

  before_validation :replace_nil_to_empty_at_memo, on: :create

  validates :name, presence: true
  validates :name, length: { in: 1 .. 50 }
  validates :name, format: { without: /\A(\s|　)+\Z/ }

  validates :memo, length: { maximum: 250 }

  # def self.active_ids
  #   self.active_only.map { |obj| obj.id }
  # end

  def remove
    self.update_attributes removed_at: Time.now
  end

  def remove!
    self.update_attributes! removed_at: Time.now
  end

  def removed?
    self.removed_at >= Time.new(THRESHOLD_YEAR, 1, 1)
  end

  def active?
    ! removed?
  end

  def replace_nil_to_empty_at_memo
    self.memo = '' if self.memo.nil?
  end
end
