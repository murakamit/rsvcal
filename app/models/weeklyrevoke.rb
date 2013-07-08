# -*- coding: utf-8 -*-

class Weeklyrevoke < ActiveRecord::Base
  belongs_to :weekly

  include Memoable
  include Removable

  validates :weekly_id, presence: true
  validate :validate_presence_weekly

  validates :applicant, presence: true
  validates :applicant, length: { in: 1 .. 50 }
  validates :applicant, format: { without: /\A(\s|　)+\Z/ }

  validates :date, presence: true
  validate :validate_date

  def validate_presence_weekly
    k = :weekly_id
    errors.add k, "No such weekly reservation" unless Weekly.exists? self[k]
  end

  def validate_date
    if self.date.wday == self.weekly.wday
      if self.date < self.weekly.date_begin
        errors.add :date, "'revoke' must be later than 'reservation'"
      end
    else
      errors.add :date, "different day of the week"
    end
  end
end
