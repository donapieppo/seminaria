include ActionView::Helpers::NumberHelper

module MoneyHelper
  def euro(num)
    num ? number_to_currency(num, unit: "€", separator: ",", locale: :it) : "-"
  end
end
