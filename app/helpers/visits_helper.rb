module VisitsHelper
  def weekend?(date)
    [0, 6].include?(date&.wday)
  end
end
