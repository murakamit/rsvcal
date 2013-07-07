# coding: utf-8

class Group < ActiveRecord::Base
  has_one :room

  include Nameable
  include Memoable
  include Removable
end
