class ReservationsController < ApplicationController
  include ErrorDisplayable
  include DateValidatable
  include IconHelper

  def index
    @page_title = "Reservation(s)"
    @reservations = Reservation.order(:id).reverse_order.first(100)
  end

  def show
    id = params[:id]
    @rsv = Reservation.find id
    @page_title = "Reservation ##{id}"
  rescue
    redirect_to @rsv, alert: "No such reservation(##{id})"
  end

  def new
    @page_title = "Create new reservation"
    @rsv = Reservation.new
    x = params[:item_id]
    @rsv[:item_id] = x if x.present? && Item.where(id: x).present?
    d = generate_date_if_valid params[:date]
    @rsv[:date] = d if d
    @rsv[:begin_h] = "13"
    @rsv[:begin_m] = "00"
    @rsv[:end_h] = "14"
    @rsv[:end_m] = "00"
    x = icon2number @rsv.icon
    @rsv.icon = x if x
  end

  def create
    @rsv = Reservation.create myparams
    if @rsv.save
      flash[:newrid] = @rsv.id
      redirect_to @rsv.item, notice: "reserved."
    else
      display_errors @rsv.errors, :new, "Create new reservation"
    end
  end

  def edit
    id = params[:id]
    @rsv = Reservation.find id
    @page_title = "Edit reservation ##{id}"
    x = icon2number @rsv.icon
    @rsv.icon = x if x
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
    redirect_to r.item, notice: "canceled."
  rescue
    redirect_to r.item
  end

  # --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
  private
  def myparams
    a = [ :item_id, :user, :date,
          :begin_h, :begin_m, :end_h, :end_m, :icon, :memo ]
    h = params.require(:reservation).permit(a)

    case params[:icon_radio]
    when 0, "0"
      m = /\A(\d+)\Z/.match params[:icon_select]
      h[:icon] = "&##{m[1]};" if m
    end

    h
  end

  def display_errors(errors, rendering_page, page_title)
    x = icon2number @rsv.icon
    @rsv.icon = x if x
    super
  end
end
