# -*- coding: utf-8 -*-

class Weekly < ActiveRecord::Base
  belongs_to :item

  include Userable

  include Memoable
  include Removable

  before_validation :replace_7_to_0_at_wday

  validates :item_id, presence: true

  validates :wday, {
    presence: true,
    numericality: {
      only_integer: true,
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: 6,
    }
  }

  def replace_7_to_0_at_wday
    self.wday = 0 if self.wday == 7
  end
end
