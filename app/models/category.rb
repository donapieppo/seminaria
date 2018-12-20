# Si tratta dei nomi dei fondi ('P.R.I.N. - Ex 40%', 'Progetto Strategico', etc etc
class Category < ActiveRecord::Base
  has_many :funds
end


