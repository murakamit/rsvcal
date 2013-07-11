# -*- coding: utf-8 -*-

module Nameable
  extend ActiveSupport::Concern

  included do
    validates :name, presence: true
    # validates :name, uniqueness: { scope: -> { where() } }
    validates :name, length: { in: 1 .. 50 }
    validates :name, format: { without: /\A(\s|　)+\Z/ }
  end
end
