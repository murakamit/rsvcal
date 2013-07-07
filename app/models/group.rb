# coding: utf-8

class Group < ActiveRecord::Base
  has_many :items

  include Nameable
  include Memoable
  include Removable

  # --- --- --- --- --- --- --- --- --- --- --- ---
  # def remove
  #   super
  # end
end
