# coding: utf-8

class Group < ActiveRecord::Base
  has_many :rooms

  include Nameable
  include Memoable
  include Removable

  # --- --- --- --- --- --- --- --- --- --- --- ---
  # def remove
  #   super
  # end
end
