# -*- coding: utf-8 -*-

class Reservation < ActiveRecord::Base
  belongs_to :item

  include Userable
  include Durationable
  include Iconable
  include Memoable
  include Removable

  validates :item_id, presence: true
  validate :validate_presence_item

  validates :date, presence: true

  def validate_presence_item
    k = :item_id
    errors.add k, "No such item" if Item.where(id: self[k]).empty?
  end

  def self.default_icon
    "&#9734;" # star
  end
end
