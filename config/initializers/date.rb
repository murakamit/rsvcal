Date.class_eval {
  alias ymd iso8601

  def to_s
    iso8601 + "(#{strftime '%A'})"
  end  
}
