namespace :seminaria do

  desc "add spkr token in all repayments"
  task add_spkr_token: :environment do
    Repayment.where(spkr_token: nil).each do |r|
      r.create_spkr_token 
    end
  end

end
