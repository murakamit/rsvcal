class WeekliesController < ApplicationController
  include ErrorDisplayable
  include IconHelper

  def index
    @page_title = "Weekly Reservations"
  end

  def show
    id = params[:id]
    @weekly = Weekly.find id
    @page_title = generate_title @weekly
  rescue
    redirect_to weeklies_path, alert: "No such weekly reservation(##{id})"
  end

  def new
    @page_title = "Create new weekly reservation"
    @weekly = Weekly.new
    x = params[:item_id]
    @weekly[:item_id] = x if x.present? && Item.where(id: x).present?
    set_date_begin @weekly, params[:date_begin]
    @weekly[:begin_h] = "13"
    @weekly[:begin_m] = "00"
    @weekly[:end_h] = "14"
    @weekly[:end_m] = "00"
    x = icon2number @weekly.icon
    @weekly.icon = x if x
  end

  def create
    @weekly = Weekly.create myparams
    if @weekly.save
      redirect_to weeklies_path, notice: "created."
    else
      display_errors @weekly.errors, :new, "Create weekly reservation"
    end
  end

  def edit
    @weekly = Weekly.find params[:id]
    @weekly.date_end = nil if @weekly.forever?
    x = icon2number @weekly.icon
    @weekly.icon = x if x
    @page_title = generate_title @weekly
  rescue
    redirect_to weeklies_path
  end

  def update
    @weekly = Weekly.find params[:id]
    user = @weekly.user
    if @weekly.update myparams
      redirect_to @weekly, notice: "updated."
    else
      display_errors @weekly.errors, :edit, generate_title(@weekly)
    end
  rescue
    redirect_to weeklies_path
  end

  def destroy
    w = Weekly.find params[:id]    
    w.remove
    redirect_to weeklies_path, notice: "deleted."
  rescue
    redirect_to weeklies_path
  end

  # --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
  private
  def myparams
    a = [ :item_id, :user, :date_begin, :date_end,
          :begin_h, :begin_m, :end_h, :end_m, :icon, :memo ]
    h = params.require(:weekly).permit(a)

    k = :date_end
    x = h[k]
    h.delete k if x && Weekly.forever?(x)

    case params[:date_end_radio]
    when 0, "0"
      h.delete :date_end
    end

    case params[:icon_radio]
    when 0, "0"
      m = /\A(\d+)\Z/.match params[:icon_select]
      h[:icon] = "&##{m[1]};" if m
    end

    h
  end

  def set_date_begin(obj, s)
    k = :date_begin
    m = /\A(\d{4})-(\d{1,2})-(\d{1,2})\Z/.match s
    if m
      a = m[1..3].map(&:to_i)
      obj[k] = Date.new(*a) if Date.valid_date?(*a)
    end
    obj[k] = Date.today if obj[k].blank?
  end

  def generate_title(obj)
    "#{obj.user}@#{obj.item.name},#{obj.date_begin.strftime "%A"}"
  end

  def display_errors(errors, rendering_page, page_title)
    @weekly.date_end = nil if @weekly.forever?
    x = icon2number @weekly.icon
    @weekly.icon = x if x
    super
  end
end
