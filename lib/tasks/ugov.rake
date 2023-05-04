require "csv"

namespace :seminaria do
  desc "Import UGOV"
  task import_ugov: :environment do
    CSV.read(ARGV[0], quote_char: nil, col_sep: "|").each do |line|
      num_reg = line[2].to_i
      description = line[4]
      cf = line[8]

      if num_reg > 0 && cf && description =~ /semin/i
        subject = line[5]
        date_from = line[12] ? Date.strptime(line[12], "%m/%d/%Y") : nil
        date_to = line[13] ? Date.strptime(line[13], "%m/%d/%Y") : nil

        Repayment.where("notified IS NOT NULL AND taxid IS NOT NULL AND ugov IS NULL").each do |repayment|
          if repayment.taxid.include?(cf.upcase) 
            if date_from <= repayment.seminar.date.to_date && repayment.seminar.date.to_date <= date_to
              p [num_reg, subject, description, cf, date_from, date_to]
              p repayment
              p repayment.seminar
              repayment.update_attribute(:ugov, num_reg)
              puts "----------------"
              puts " "
              break
            end
          end
        end
      end
    end
  end
end
