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
    set_date_begin @weekly, params[:date_begin]
    set_icon_on_new @weekly
  end

  def create
    @weekly = Weekly.create myparams
    if @weekly.save
      redirect_to :index, notice: "created."
    else
      # display_errors @weekly.errors, :new, "Create weekly reservation"
      s = myparams.inspect
      [:date_end_radio, :date_icon_radio, :date_icon_select].each { |k|
        s += "<br>params[#{k}] = #{params[k]}"
      }
      render text: s.html_safe
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
    h = params.require(:weekly).permit(a)

    case params[:date_end_radio]
    when 0, "0"
      h.delete :date_end
    end

    case params[:date_icon_radio]
    when 0, "0"
      m = /\A(\d+)\Z/.match params[:date_icon_select]
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

  def icon2number(s)
    m = /\A&#(\d+);\Z/.match s.to_s
    m ? m[1] : nil
  end

  def set_icon_on_new(obj)
    k = :icon
    s = Weekly.default_icon
    if s
      x = icon2number s
      obj[k] = x.presence || s
    else
      obj[k] = 9834
    end
  end

  def set_icon(obj, s)
    k = :icon
    case s
    when /\A&#\d+;\Z/
      obj[k] = s
    when /\A(\d+)\Z/
      obj[k] = "&##{$1};"
    else
      obj[k] = s
    end
  end
end
