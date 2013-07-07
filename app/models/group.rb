# coding: utf-8

class Group < ActiveRecord::Base
  has_many :items

  include Nameable
  include Memoable
  include Removable

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
      raise "Group not empty"
    end
  end
end
