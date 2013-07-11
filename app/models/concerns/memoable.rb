# -*- coding: utf-8 -*-

module Memoable
  extend ActiveSupport::Concern

  included do
    before_validation :replace_nil_to_empty_at_memo
    validates :memo, length: { maximum: 250 }
  end

  def replace_nil_to_empty_at_memo
    self.memo = '' if self.memo.nil?
  end
end
