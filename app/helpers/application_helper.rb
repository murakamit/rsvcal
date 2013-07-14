module ApplicationHelper
  def select_items_tag(form, key, selected = nil)
    groups = Group.order(:name)
    return "" if groups.empty?
    h = Hash.new { |h_, k_| h_[k_] = [] }
    groups.each { |g|
      g.items.order(:name).each { |item| 
        h[g.name] << [item.name, item.id]
      }
    }
    form.select key, grouped_options_for_select(h, selected: selected)
  end

  def x2time(x)
    m = /\A(\d{1,2})(\d{2})\Z/.match x.to_s
    m ? sprintf("%02d:%s", m[1].to_i, m[2]) : nil
  end

  def combine_hm(obj, prekey)
    h = obj["#{prekey}_h"]
    m = obj["#{prekey}_m"]
    return nil if h.blank? || m.blank?
    sprintf "%d:%02d", h.to_i, m.to_i
  end
end
