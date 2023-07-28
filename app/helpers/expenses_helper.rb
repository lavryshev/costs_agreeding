module ExpensesHelper
  def sort_link(sorting:, field:, label:, filter:)
    direction = if field == sorting['field']
                  next_direction sorting['direction']
                else
                  'asc'
                end
    link_to label, expenses_path({ field:, direction: }.merge(filter))
  end

  def next_direction(cur_direction)
    cur_direction == 'asc' ? 'desc' : 'asc'
  end

  def sort_indicator(cur_direction)
    if cur_direction == 'asc'
      '^'
    elsif cur_direction == 'desc'
      'v'
    end
  end
end
