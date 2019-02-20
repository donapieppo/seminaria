namespace :seminaria do

  desc "convert roles in users"
  task convert_roles: :environment do
    Repayment.where('role IS NOT NULL').find_each do |repayment|
      old_role = repayment.role.downcase.strip
      position = position_id = nil

      if old_role =~ /former/
        position = 'Altro'
        position_id = 8
      elsif old_role =~ /ricercatore/ or old_role =~ /researcher/ or old_role =~ /assistant/
        position = 'Ricercatore'
        position_id = 3
      elsif old_role =~ /^professor$/ # solo professor
        position = 'Professore associato'
        position_id = 1
      elsif old_role =~ /ordinari/ or old_role =~ /full professor/
        position = 'Professore ordinario'
        position_id = 1
      elsif old_role =~ /associat/ # associate associato
        position = 'Professore associato'
        position_id = 2
      elsif old_role =~ /assegnist/ or old_role =~ /post.?doc/
        position = 'Titolare di assegno di ricerca'
        position_id = 4
      elsif old_role =~ /dottore di ricerc/ or old_role =~ /dottorato in/ or old_role =~ /phd student/ or old_role =~ /ph\.d/
        position = 'Dottore di ricerca'
        position_id = 5
      elsif old_role =~ /dottorand/ or old_role =~ /studente di dottorato/
        position = 'Dottorando di ricerca'
        position_id = 6
      elsif old_role =~ /emerit/ or old_role =~ /distinguished/ # emerito emeritus
        position = 'Professore Emerito'
        position_id = 7
      else
        position = 'Altro'
        position_id = 8
      end
      puts "#{old_role} -> #{position}"
      repayment.update_attribute(:position_id, position_id)
    end
  end
end

# INSERT INTO `positions` VALUES (1, "po", "Professore ordinario"),
#                                (2, "pa", "Professore associato"),
#                                (3, "ri", "Ricercatore"),
#                                (4, "ass", "Titolare di assegno di ricerca"),
#                                (5, "phd", "Dottore di ricerca"),
#                                (6, "phdstudent", "Dottorando di ricerca"), 
#                                (7, "emeritus", "Professore Emerito"),
#                                (8, "other", "Altro");
