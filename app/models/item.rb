# -*- coding: utf-8 -*-

class Item < ActiveRecord::Base
  belongs_to :group
  has_many :weeklies

  include Nameable
  include Memoable
  include Removable

  validates :group_id, presence: true
  validates_associated :group
end
