# -*- coding: utf-8 -*-

module Removable
  extend ActiveSupport::Concern

  DEFAULT_REMOVED_YEAR = 1900
  THRESHOLD_YEAR = 2000

  included do
    def self.threshold_time
      Time.utc(THRESHOLD_YEAR).to_s(:db)
    end

    scope :removed_only, -> {
      unscoped.where("removed_at >= ?", threshold_time)
    }

    scope :active_only,  -> {
      unscoped.where("removed_at <  ?", threshold_time)
    }

    default_scope { active_only }

    before_validation :replace_removed_at_to_default, on: :create
  end

  # --- --- --- --- --- --- --- --- --- --- --- ---
  def replace_removed_at_to_default
    self.removed_at = Time.utc(DEFAULT_REMOVED_YEAR).to_s(:db)
  end

  # --- --- --- --- --- --- --- --- --- --- --- ---
  def remove
    self.update removed_at: Time.now.utc.to_s(:db)
  end

  def remove!
    self.update! removed_at: Time.now.utc.to_s(:db)
  end

  def removed?
    self.removed_at >= self.class.threshold_time
  end

  def active?
    ! removed?
  end
end
