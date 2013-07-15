class ReservationsController < ApplicationController
  include ErrorDisplayable
  include DateValidatable

  def index
    @page_title = "Reservations"
  end

  def show
    id = params[:id]
    @rsv = Reservation.find id
    @page_title = "Reservation ##{id}"
  rescue
    redirect_to @rsv, alert: "No such reservation(##{id})"
  end

  def new
    @rsv = Reservation.new
    x = params[:item_id]
    @rsv[:item_id] = x if x.present? && Item.where(id: x).present?
    d = generate_date_if_valid params[:date]
    @rsv[:date] = d if d
    @page_title = "Create new reservation"
  end

  def create
    @rsv = Reservation.create myparams
    if @rsv.save
      redirect_to @rsv.item, notice: "reserved."
    else
      display_errors @rsv.errors, :new, "Create new reservation"
    end
  end

  def edit
    id = params[:id]
    @rsv = Reservation.find id
    @page_title = "Edit reservation ##{id}"
  rescue
    redirect_to reservations_path
  end

  def update
    id = params[:id]
    @rsv = Reservation.find id
    if @rsv.update myparams
      redirect_to @rsv, notice: "updated."
    else
      display_errors @rsv.errors, :edit, "Edit reservation ##{id}"
    end
  rescue
    redirect_to reservations_path
  end

  def destroy
    r = Reservation.find params[:id]    
    r.remove
    redirect_to r.item, notice: "deleted."
  rescue
    redirect_to r.item
  end

  # --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
  private
  def myparams
    a = [ :item_id, :user, :date,
          :begin_h, :begin_m, :end_h, :end_m, :icon, :memo ]
    params.require(:reservation).permit(a)
  end
end
