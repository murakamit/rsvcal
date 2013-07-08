# -*- coding: utf-8 -*-

module Weekable
  extend ActiveSupport::Concern

  def infinity_year
    9999
  end

  def infinity_date
    Date.new infinity_year, 12, 31
  end

  # module_function :infinity_year, :infinity_date

  def replace_nil_to_infinity_at_date_end
    self.date_end = infinity_date if self.date_end.nil?
  end

  # --- --- --- --- --- --- --- --- --- --- --- ---
  included do
    before_validation :replace_nil_to_infinity_at_date_end
    validates :date_begin, presence: true
    validates :date_end, presence: true
    validate :validate_date_begin_end
  end

  # --- --- --- --- --- --- --- --- --- --- --- ---
  def wday
    self.date_begin.wday
  end

  def infinity?
    self.date_end >= Date.new(infinity_year, 1, 1)
  end

  alias forever? infinity?

  def has_end?
    ! infinity?
  end

  # def date_end
  #   infinity? ? nil : super
  # end

  def validate_date_begin_end
    # if has_date_end? && (self.date_begin >= self.date_end)
    #   errors.add :date_end, "'end' must be later than 'begin'"
    # end
  end
end
