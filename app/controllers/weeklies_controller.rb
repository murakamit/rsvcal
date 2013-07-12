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
    # @errors = flash[:errors]
    @weekly = Weekly.new
  end

  def create
    a = [ :item_id, :user, :date_begin, :date_end,
          :begin_h, :begin_m, :end_h, :end_m, :icon, :memo ]
    @weekly = Weekly.create params.require(:weekly).permit(a)
    if @weekly.save
      redirect_to :index, notice: "created."
    else
      # e = @weekly.errors
      # flash[:errors] = e
      # n = e.size
      # redirect_to new_weekly_path, alert: "#{n} error#{'s' if n > 1}"
      @page_title = "Create new weekly reservation"
      @errors = @weekly.errors
      n = @errors.size
      flash[:alert] = "#{n} error#{'s' if n > 1}"
      render :new
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
