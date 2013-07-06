# coding: utf-8

class Item < ActiveRecord::Base
  belongs_to :group

  include Nameable
  include Memoable
  include Paranoid

  validates :group_id, presence: true
end
