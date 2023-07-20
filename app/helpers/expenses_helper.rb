module ExpensesHelper
  
  def sort_link(sort:, field:, label:, filter_params:)
    if field == sort[:field]
      direction = next_direction sort[:direction]
    else
      direction = 'asc'
    end
    link_to label, expenses_path({field: field, direction: direction}.merge(filter_params))
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
