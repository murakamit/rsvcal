# -*- coding: utf-8 -*-

module BeginEndable
  extend ActiveSupport::Concern

  included do
    validates :begin_h, {
      presence: true,
      numericality: { only_integer: true },
      inclusion: { in: 0 .. 23 },
    }

    validates :begin_m, {
      presence: true,
      numericality: { only_integer: true },
      inclusion: { in: [0, 30] },
    }

    validates :end_h, {
      presence: true,
      numericality: { only_integer: true },
      inclusion: { in: 0 .. 23 },
    }

    validates :end_m, {
      presence: true,
      numericality: { only_integer: true },
      inclusion: { in: [0, 30] },
    }
    validate :validates_begin_end
  end

  def begin2sec
    self.begin_h * 60 * 60 + self.begin_m * 60
  end

  def end2sec
    self.end_h * 60 * 60 + self.end_m * 60
  end

  def hm_to_s(h, m, padding_h = 1, padding_m = 2)
    sh = sprintf "%0#{padding_h}d", h
    sm = sprintf "%0#{padding_m}d", m
    sh + ':' + sm
  end

  module_function :hm_to_s

  def begin_to_s(padding_h = 1, padding_m = 2)
    hm_to_s(self.begin_h, self.begin_m, padding_h, padding_m)
  end

  def end_to_s(padding_h = 1, padding_m = 2)
    hm_to_s(self.end_h, self.end_m, padding_h, padding_m)
  end

  def validates_begin_end
    if begin2sec >= end2sec
      errors.add :end_h, "'end' must be later than 'begin'"
    end
  end
end
