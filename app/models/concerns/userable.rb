# -*- coding: utf-8 -*-

module Userable
  extend ActiveSupport::Concern

  included do
    validates :user, presence: true
    validates :user, length: { in: 1 .. 50 }
    validates :user, format: { without: /\A(\s|　)+\Z/ }
  end
end
