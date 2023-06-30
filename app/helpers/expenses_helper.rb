module ExpensesHelper
  def sort_link(field:, label:)
    if field == params[:field]
      direction = next_direction
    else
      direction = 'asc'
    end
    link_to label, expenses_path(field: field, direction: direction)
  end

  def next_direction
    params[:direction] == 'asc' ? 'desc' : 'asc'
  end

  def sort_indicator
    if params[:direction] == 'asc'
      '^'
    elsif params[:direction] == 'desc'
      'v'
    end
  end
end
