# -*- coding: utf-8 -*-

class User < ActiveRecord::Base
  include Nameable
  include Memoable
  include Removable

  # validates :password_digest, presence: true
  validates :admin, presence: true
  validates :admin, inclusion: { in: [true, false] }
end
