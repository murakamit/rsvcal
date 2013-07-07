# -*- coding: utf-8 -*-

class Weekly < ActiveRecord::Base
  belongs_to :item

  include Userable

  include Memoable
  include Removable

  validates :item_id, presence: true
end
