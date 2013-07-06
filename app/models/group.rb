# coding: utf-8

class Group < ActiveRecord::Base
  has_one :room

  # --- --- --- --- --- --- --- --- --- --- --- ---
  DEFAULT_REMOVED_YEAR = 1900
  THRESHOLD_YEAR = 2000

  def self.threshold_time
    Time.new THRESHOLD_YEAR
  end

  scope :removed_only, -> { where("removed_at >= ?", threshold_time) }
  scope :active_only,  -> { where("removed_at <  ?", threshold_time) }
  default_scope { active_only }

  # --- --- --- --- --- --- --- --- --- --- --- ---
  before_validation :replace_nil_to_empty_at_memo, on: :create
  before_validation :replace_removed_at_to_default, on: :create

  def replace_nil_to_empty_at_memo
    self.memo = '' if self.memo.nil?
  end

  def replace_removed_at_to_default
    self.removed_at = Time.new(DEFAULT_REMOVED_YEAR)
  end

  # --- --- --- --- --- --- --- --- --- --- --- ---
  validates :name, presence: true
  validates :name, length: { in: 1 .. 50 }
  validates :name, format: { without: /\A(\s|　)+\Z/ }

  validates :memo, length: { maximum: 250 }

  # --- --- --- --- --- --- --- --- --- --- --- ---
  def remove
    self.update removed_at: Time.now
  end

  def remove!
    self.update! removed_at: Time.now
  end

  def removed?
    self.removed_at >= self.class.threshold_time
  end

  def active?
    ! removed?
  end
end
