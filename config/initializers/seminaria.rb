CESIA_UPN = ["pietro.donatini@unibo.it"]

module Seminaria
  class Application < Rails::Application
    config.repayment_deadline = 14 # 8 days for working on repayment/refund before speaker arrival
    config.on_line_repayment_deadline_1 = 5  # 5 giorni prima della giunta
    config.on_line_repayment_deadline_2 = 10 # 10 fra la giunta e inizio del seminario
  end
end
