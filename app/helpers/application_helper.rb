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
end
