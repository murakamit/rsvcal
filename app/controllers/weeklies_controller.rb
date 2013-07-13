class WeekliesController < ApplicationController
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
    set_date_begin(@weekly)
  end

  def create
    a = [ :item_id, :user, :date_begin, :date_end,
          :begin_h, :begin_m, :end_h, :end_m, :icon, :memo ]
    @weekly = Weekly.create params.require(:weekly).permit(a)
    if @weekly.save
      redirect_to :index, notice: "created."
    else
      @page_title = "Create new weekly reservation"
      @errors = @weekly.errors
      n = @errors.size
      @errormes = "#{n} error#{'s' if n > 1}"
      render :new
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
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
