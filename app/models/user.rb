# -*- coding: utf-8 -*-

class User < ActiveRecord::Base
  has_secure_password

  include Nameable
  include Memoable
  include Removable

  REX_PASSWORD = /\A[!-~]+\Z/

  validate :uniq_name
  validates :password, format: { with: REX_PASSWORD }

  # --- --- --- --- --- --- --- --- --- --- --- ---
  def uniq_name
    k = :name
    a = self.class.active_only.where.not(id: self.id).pluck(k).flatten
    errors.add k, "must be unique" if a.include? self[k]
  end

  # --- --- --- --- --- --- --- --- --- --- --- ---
  def self.valid_password?(s)
    REX_PASSWORD === s
  end

  def admin?
    self.admin
  end
end
