# -*- coding: utf-8 -*-

module ErrorDisplayable
  # extend ActiveSupport::Concern

  # included do
  # end

  def display_errors(errors, rendering_page, page_title)
    @page_title = page_title
    @errors = errors
    n = errors.size
    @errormes = "#{n} error#{'s' if n > 1}"
    render rendering_page
  end
end
