# -*- coding: utf-8 -*-

class Group < ActiveRecord::Base
  has_many :items

  include Nameable
  include Memoable
  include Removable

  class RemoveError < StandardError; end

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
