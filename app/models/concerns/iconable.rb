# -*- coding: utf-8 -*-

module Iconable
  extend ActiveSupport::Concern

  included do
    before_validation :normalize_icon
    validates :icon, length: { maximum: 50 }
  end

  REX_WHITE = /\A(\s|　)*\Z/
  REX_ENTITY = /\A&([a-z]+|#\d+);\Z/

  def normalize_icon
    s = self.icon
    case s
    when REX_WHITE, nil
      self.icon = self.class.default_icon
    when REX_ENTITY
      # nop
    else
      self.icon = ERB::Util.html_escape s.chr
    end
  end
end
