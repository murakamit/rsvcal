module ApplicationHelper
  # --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
  WDAYS_EN = %W(Sunday Monday Tuesday Wednesday Thursday Friday Saturday)

  # --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
  def select_items_tag(form, key, selected = nil)
    groups = Group.order(:name)
    return "" if groups.empty?
    ActiveRecord::Base.transaction do
      h = Hash.new { |h_, k_| h_[k_] = [] }
      groups.each { |g|
        g.items.order(:name).each { |item| 
          h[g.name] << [item.name, item.id]
        }
      }
      if selected
        form.select key, grouped_options_for_select(h, selected: selected)
      else
        form.select key, grouped_options_for_select(h, selected: selected), include_blank: true
      end
    end
  end

  # --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
  def x2time(x)
    m = /\A(\d{1,2})(\d{2})\Z/.match x.to_s
    m ? sprintf("%02d:%s", m[1].to_i, m[2]) : nil
  end

  # --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
  def combine_hm(obj, prekey)
    h = obj["#{prekey}_h"]
    m = obj["#{prekey}_m"]
    return nil if h.blank? || m.blank?
    sprintf "%d:%02d", h.to_i, m.to_i
  end

  # --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
  def wday_item_weekly
    return nil if Weekly.all.empty?
    ActiveRecord::Base.transaction do
      h1 = Weekly.order(:begin_h).group_by { |w| w.wday }
      a1 = h1.to_a.sort { |x,y| x.first <=> y.first }
      a1.map { | wday, a2 |
        h2 = a2.group_by { |x| Item.find(x.item_id) }
        a3 = h2.to_a.sort { |x,y|
          Item.find(x.first).name <=> Item.find(y.first).name
        }
        [wday, a3]
      }
    end
  end

  # --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
  def select_revoke_tag(form, key, selected = nil)
    ary = wday_item_weekly.map { | pair1 |
      wday, a = pair1
      b = []

      a.each { | pair2 |
        pair2.last.each { | w |
          b << ["#{w.id} = #{w.user}@#{w.item.name}", w.id]
        }
      }

      [WDAYS_EN[wday], b]
    }

    if selected
      form.select key, grouped_options_for_select(ary, selected: selected)
    else
      form.select key, grouped_options_for_select(ary, selected: selected), include_blank: true
    end
  end

  # --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
  def select_hm_tag(form, prekey)
    sh = form.select :"#{prekey}_h", (8..20).to_a
    sm = form.select :"#{prekey}_m", [["00", 0],  ["30", 30]]
    sh + " : " + sm
  end

  # --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
  def select_icon_tag0(marks, icon_number,
                       radio_name = "icon_radio", select_name = "icon_select")
    s = %Q(<input type="radio" name="#{radio_name}" value="0" style="margin-right:8px")
    s += " checked" if marks.include?(icon_number)
    s += ">"

    s += %Q(<select name="#{select_name}" onChange="document.getElementsByName('#{radio_name}')[0].checked = true;">)

    marks.each { |x|
      z = (icon_number && (x == icon_number)) ? " selected" : nil
      s += %Q(<option value="#{x}"#{z}>&##{x};</option>)
    }

    (s + "</select>").html_safe
  end


  # --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
  def select_icon_tag1(form, marks, icon_number,
                       radio_name = "icon_radio", select_name = "icon_select")
    marks_included = marks.include? icon_number

    s = %Q(<input type="radio" name="#{radio_name}" value="1" style="margin-right:8px")
    s += " checked" unless marks_included
    s += ">"

    args = {
      maxlength: 1,
      style: "width:2em;",
      onChange: "document.getElementsByName('#{radio_name}')[1].checked = true;".html_safe
    }

    if marks_included
      args[:value] = ""
    else
      args[:value] = "" if icon_number
    end

    (s + form.text_field(:icon, args)).html_safe
  end
end
