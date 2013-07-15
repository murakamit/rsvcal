class WeeklyrevokesController < ApplicationController
  include ErrorDisplayable

  def show
    id = params[:id]
    @revoke = Weeklyrevoke.find id
    @page_title = "Revocation of #{generate_title @revoke}"
  rescue
    redirect_to @revoke, alert: "No such revocation(##{id})"
  end

  def new
    @revoke = Weeklyrevoke.new
    x = params[:weekly_id]
    @revoke[:weekly_id] = x if x.present? && Weekly.where(id: x).present?
    set_date @revoke, params[:date]
    @page_title = "Revoke the day"
  end

  def create
    @revoke = Weeklyrevoke.create myparams
    if @revoke.save
      redirect_to @revoke.weekly, notice: "revoked. (#{@revoke.date})"
    else
      display_errors @revoke.errors, :new, "Revoke the day"
    end
  end

  def destroy
    r = Weeklyrevoke.find params[:id]    
    r.remove
    redirect_to r.weekly, notice: "retrieved."
  rescue
    redirect_to weeklies_path
  end

  # --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
  private
  def generate_title(obj)
    w = obj.weekly
    "#{w.item.name}@#{w.date_begin.strftime "%A"}"
  end

  def set_date(obj, s)
    k = :date
    m = /\A(\d{4})-(\d{1,2})-(\d{1,2})\Z/.match s
    return unless m
    a = m[1..3].map(&:to_i)
    obj[k] = Date.new(*a) if Date.valid_date?(*a)
  end

  def myparams
    a = [:weekly_id, :applicant, :date, :memo]
    params.require(:weeklyrevoke).permit a
  end
end
