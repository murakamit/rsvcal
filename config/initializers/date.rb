Date.class_eval {
  alias ymd iso8601

  def ymdw
    iso8601 + "(#{strftime '%A'})"
  end  
}
