# -*- coding: utf-8 -*-

class Weekly < ActiveRecord::Base
  belongs_to :item

  include Userable
  include Weekable
  include Durationable
  include Iconable
  include Memoable
  include Removable

  validates :item_id, presence: true
  validate :validate_presence_item

  def validate_presence_item
    k = :item_id
    errors.add k, "No such item" unless Item.exists? self[k]
  end

  def self.default_icon
    "&#9834;" # 8th note
  end
end
