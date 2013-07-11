# -*- coding: utf-8 -*-

class Group < ActiveRecord::Base
  has_many :items

  include Nameable
  include Memoable
  include Removable

  class RemoveError < StandardError; end

  validate :uniq_name

  # --- --- --- --- --- --- --- --- --- --- --- ---
  def uniq_name
    k = :name
    a = self.class.active_only.where.not(id: self.id).pluck(k).flatten
    errors.add k, "must be unique" if a.include? self[k]
  end

  # --- --- --- --- --- --- --- --- --- --- --- ---
  def remove
    if self.items.empty?
      super
    else
      false
    end
  end

  def remove!
    if self.items.empty?
      super
    else
      raise RemoveError, "Group not empty"
    end
  end
end
