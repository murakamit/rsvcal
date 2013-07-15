module IconHelper
  def icon2number(s)
    m = /\A&#(\d+);\Z/.match s.to_s
    m ? m[1] : nil
  end

  # def set_icon(obj, s)
  #   k = :icon
  #   case s
  #   when /\A&#\d+;\Z/
  #     obj[k] = s
  #   when /\A(\d+)\Z/
  #     obj[k] = "&##{$1};"
  #   else
  #     obj[k] = s
  #   end
  # end

  module_function :icon2number
end
