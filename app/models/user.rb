# -*- coding: utf-8 -*-

class User < ActiveRecord::Base
  has_secure_password

  include Nameable
  include Memoable
  include Removable

  REX_PASSWORD = /\A[!-~]+\Z/

  validates :name, uniqueness: true
  validates :password, format: { with: REX_PASSWORD }

  def self.valid_password?(s)
    REX_PASSWORD === s
  end

  def admin?
    self.admin
  end
end
