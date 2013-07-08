# -*- coding: utf-8 -*-

class Weekly < ActiveRecord::Base
  belongs_to :item

  include Userable
  include Durationable
  include Iconable
  include Memoable
  include Removable

  validates :item_id, presence: true
  validates_associated :item

  def self.default_icon
    "&#9834;" # 8th note
  end
end
