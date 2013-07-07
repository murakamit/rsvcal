# coding: utf-8

class Group < ActiveRecord::Base
  has_many :room

  include Nameable
  include Memoable
  include Removable

  # --- --- --- --- --- --- --- --- --- --- --- ---
  # def remove
  #   super
  # end
end
