# -*- coding: utf-8 -*-

module Weekable
  extend ActiveSupport::Concern

  INFINITY_YEAR = 9999

  # --- --- --- --- --- --- --- --- --- --- --- ---
  included do
    before_validation :replace_nil_to_infinity_at_date_end
    validates :date_begin, presence: true
    validates :date_end, presence: true
    validate :validate_date_begin_end

    def self.infinity_date
      Date.new INFINITY_YEAR, 12, 31
    end

    def self.infinity?(date)
      xday = Date.new INFINITY_YEAR, 1, 1
      if date.is_a? Date
        date >= xday
      elsif date.is_a? String
        m = /\A(\d{4})-(\d{1,2})-(\d{1,2})\Z/.match date
        if m
          date = Date.new *(m[1..3].map(&:to_i))
          date >= xday
        else
          false
        end
      elsif date.is_a? NilClass
        true
      else
        raise ArgumentError
      end
    end

    def self.forever?(date)
      self.infinity? date
    end
  end

  # --- --- --- --- --- --- --- --- --- --- --- ---
  def replace_nil_to_infinity_at_date_end
    self.date_end = self.class.infinity_date if self.date_end.nil?
  end

  def validate_date_begin_end
    if has_end?
      if self.date_begin.wday != self.date_end.wday
        errors.add :date_end, "different day of the week"
      elsif self.date_begin >= self.date_end
        errors.add :date_end, "'end' must be later than 'begin'"
      end
    end
  end

  # --- --- --- --- --- --- --- --- --- --- --- ---
  def wday
    self.date_begin.wday
  end

  def infinity?
    self.class.infinity? self.date_end
  end

  alias forever? infinity?

  def has_end?
    ! infinity?
  end

  # def date_end
  #   infinity? ? nil : super
  # end

  def date_end_or_nil
    infinity? ? nil : date_end
  end
end
