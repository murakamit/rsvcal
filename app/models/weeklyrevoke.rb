# -*- coding: utf-8 -*-

class Weeklyrevoke < ActiveRecord::Base
  belongs_to :weekly

  include Memoable
  include Removable

  validates :weekly_id, presence: true

  validates :applicant, presence: true
  validates :applicant, length: { in: 1 .. 50 }
  validates :applicant, format: { without: /\A(\s|　)+\Z/ }

  validates :date, presence: true

  validate :validate1

  def validate1
    k = :weekly_id
    if Weekly.exists? self[k]
      if self.date.wday == self.weekly.wday
        s = "'revoke' is out of range"
        w = self.weekly
        if self.date < w.date_begin
          errors.add :date, s
        else
          errors.add :date, s if w.has_end? && (w.date_end < self.date)
        end
      else
        errors.add :date, "different day of the week"
      end
    else
      errors.add k, "No such weekly reservation"
    end
  end
end
