class WeeklyrevokesController < ApplicationController
  include ErrorDisplayable
  include DateValidatable

  def show
    id = params[:id]
    @revoke = Weeklyrevoke.find id
    @page_title = "Revocation of #{generate_title @revoke}"
  rescue => e
    render text: e
    # redirect_to @revoke, alert: "No such revocation(##{id})"
  end

  def new
    @revoke = Weeklyrevoke.new
    x = params[:weekly_id]
    @revoke[:weekly_id] = x if x.present? && Weekly.where(id: x).present?
    d = generate_date_if_valid params[:date]
    @revoke[:date] = d if d
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
    "#{obj.applicant}@#{w.item.name},#{w.date_begin.strftime "%A"}"
  end

  def myparams
    a = [:weekly_id, :applicant, :date, :memo]
    params.require(:weeklyrevoke).permit a
  end
end
