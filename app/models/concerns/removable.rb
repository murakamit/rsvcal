# -*- coding: utf-8 -*-

module Removable
  extend ActiveSupport::Concern

  DEFAULT_REMOVED_YEAR = 1900
  THRESHOLD_YEAR = 2000

  included do
    def self.threshold_remove_utc
      Time.utc(THRESHOLD_YEAR)
    end

    scope :removed_only, -> {
      unscoped.where("removed_at >= ?", threshold_remove_utc)
    }

    scope :active_only,  -> {
      unscoped.where("removed_at <  ?", threshold_remove_utc)
    }

    default_scope { active_only }

    before_validation :replace_removed_at_to_default, on: :create
  end

  # --- --- --- --- --- --- --- --- --- --- --- ---
  def replace_removed_at_to_default
    self.removed_at = Time.utc(DEFAULT_REMOVED_YEAR)
  end

  # --- --- --- --- --- --- --- --- --- --- --- ---
  def remove
    self.update removed_at: Time.now
  end

  def remove!
    self.update! removed_at: Time.now
  end

  def removed?
    self.removed_at >= self.class.threshold_remove_utc.localtime
  end

  def active?
    ! removed?
  end
end
