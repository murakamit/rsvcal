ActiveSupport::TimeWithZone.class_eval {
  def ymdw_hm
    "#{to_date.ymdw} #{strftime '%R'}"
  end
}
