module ApplicationHelper
  def to_price(number)
    number_to_currency number, unit: '', precision: 0, separator: ' '
  end

  def pretty_print_date(date)
    l date, format: :short
  end
end
