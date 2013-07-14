class WeekliesController < ApplicationController
  include ErrorDisplayable

  def index
    @page_title = "Weekly Reservations"
  end

  def show
    id = params[:id]
    @weekly = Weekly.find id
    @page_title = @weekly.name
  rescue
    redirect_to weeklies_index_path, alert: "No such weekly reservation(##{id})"
  end

  def new
    @page_title = "Create new weekly reservation"
    @weekly = Weekly.new
    x = params[:item_id]
    @weekly[:item_id] = x if x.present? && Item.where(id: x).present?
    set_date_begin @weekly
  end

  def create
    @weekly = Weekly.create myparams
    if @weekly.save
      redirect_to :index, notice: "created."
    else
      # display_errors @weekly.errors, :new, "Create weekly reservation"
      render text: "#{myparams.inspect}<br>#{params[:date_end_using]}"
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
  def myparams
    a = [ :item_id, :user, :date_begin, :date_end,
          :begin_h, :begin_m, :end_h, :end_m, :icon, :memo ]
    params.require(:weekly).permit(a)
  end

  def set_date_begin(obj)
    k = :date_begin
    m = /\A(\d{4})-(\d{1,2})-(\d{1,2})\Z/.match params[k]
    if m
      a = m[1..3].map(&:to_i)
      obj[k] = Date.new(*a) if Date.valid_date?(*a)
    end
    obj[k] = Date.today if obj[k].blank?
  end
end
