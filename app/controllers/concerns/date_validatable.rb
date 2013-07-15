# -*- coding: utf-8 -*-

module DateValidatable
  # extend ActiveSupport::Concern

  # included do
  # end

  REX_DATE = /\A(\d{4})-(\d{1,2})-(\d{1,2})\Z/

  def generate_date_if_valid(s)
    m = REX_DATE.match s
    return nil unless m
    a = m[1..3].map(&:to_i)
    Date.valid_date?(*a) ? Date.new(*a) : nil
  end

  module_function :generate_date_if_valid
end
