# -*- coding: utf-8 -*-

class User < ActiveRecord::Base
  has_secure_password
  include Nameable
  include Memoable
  include Removable

  def admin?
    self.admin
  end
end
