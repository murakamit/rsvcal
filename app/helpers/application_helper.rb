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
      form.select key, grouped_options_for_select(h, selected: selected)
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

    form.select key, grouped_options_for_select(ary, selected: selected)
  end

end
