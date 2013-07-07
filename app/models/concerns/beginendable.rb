# -*- coding: utf-8 -*-

module Beginendable
  extend ActiveSupport::Concern

  included do
    validates :begin, presence: true
    validates :end, presence: true
    validate :validate_begin_end
  end

  def same_day?(t0, t1)
    (t0.year == t1.year) && (t0.month == t1.month) && (t0.day == t1.day)
  end

  def validate_begin_end
    if self.begin >= self.end
      errors.add :end, :greater_than, count: :begin
    end

    unless same_day?(self.begin, self.end)
      errors.add :end, "no overnight"
    end

    if (self.end - self.begin) < 15.minutes
      errors.add :end, "too short time(< 15 min)"
    end
  end
end
