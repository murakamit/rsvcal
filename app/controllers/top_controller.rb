class TopController < ApplicationController
  def index
    @today = Date.today
  end
end
