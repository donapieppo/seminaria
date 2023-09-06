namespace :seminaria do
  namespace :clean do
    desc "Delete old repayments"
    task old_repayments: :environment do
      Seminar.where("YEAR(date) < 2022").find_each do |seminar|
        if (repayment = seminar.repayment)
          puts "#{repayment.id} - #{seminar.title}"
          repayment.clear_privacy!
        end
      end
    end
  end
end
