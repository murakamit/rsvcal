# -*- coding: utf-8 -*-

class Item < ActiveRecord::Base
  belongs_to :group
  has_many :weeklies

  include Nameable
  include Memoable
  include Removable

  validates :group_id, presence: true
  validate :validate_presence_group

  def validate_presence_group
    k = :group_id
    errors.add k, "No such group" unless Group.exists? self[k]
  end
end
