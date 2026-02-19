module MoneyHelper
  include ActionView::Helpers::NumberHelper

  def euro(num)
    num ? number_to_currency(num, unit: "€", separator: ",", locale: :it) : "-"
  end
end
