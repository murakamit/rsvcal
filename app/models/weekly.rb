# -*- coding: utf-8 -*-

class Weekly < ActiveRecord::Base
  belongs_to :item

  include Userable

  include Memoable
  include Removable

  before_validation :replace_7_to_0_at_wday

  validates :item_id, presence: true
  validates_associated :item

  validates :wday, {
    presence: true,
    numericality: {
      only_integer: true,
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: 6,
    }
  }

  validates :begin, presence: true
  validates :end, presence: true
  validate :begin_end

  def replace_7_to_0_at_wday
    self.wday = 0 if self.wday == 7
  end

  def same_day?(t0, t1)
    (t0.year == t1.year) && (t0.month == t1.month) && (t0.day == t1.day)
  end

  def begin_end
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
