require 'roo' 
require 'roo-xls'

class UniboFileError < RuntimeError; end
class UniboFileMissingDissertationError < RuntimeError; end

# pass an excel file from unibo almaesami
# excel = UniboFileParser.new('/tmp/pippo')
 
 
# {:codice_identificativo_progetto=>0, :nome_progetto=>1, :data_inizio=>2, :data_fine=>3, :livello_progetto=>4, :tipo_progetto=>5, :schema_di_finanziamento=>6, :ru_responsabile=>7, :stato=>8, :uo_responsabile=>9, :cup=>10, :finanziatori=>11, :codice_progetto_proprio=>12, :macro_tipo=>13, :classe=>14, :importo_progetto_€=>15, :note=>16}
class UniboFileParser
  EXCEL_FIELDS  = [:codice_identificativo_progetto, :nome_progetto, :data_inizio, :data_fine, :ru_responsabile, :importo_progetto_€]
  HEADERS_LINES_NUMBER = 2

  def initialize(file)
    # excel = file =~/xslx/ ? Roo::Excelx.new(file) : Roo::Excel.new(file)
    excel = Roo::Excel.new(file) 
    @file_content = excel.parse.drop(HEADERS_LINES_NUMBER - 1) # le prime righe sono headers
    # :codice_identificativo_progetto=>0, :nome_progetto=>1, :data_inizio=>2, :data_fine=>3
    @field2num = match_fields(@file_content.delete_at(0)) # parso e cancello la prima riga degli headers

    # fix!
    # check!
  end

  # ex: excel = ThesisImport.new(ARGV[1])
  #     excel.each(:nome, :cognome, :email) do |row|
  #     end
  def each
    @file_content.each do |excel_line|
      row = Hash.new # nome: "Pietro", cognome: "Donatini", upn: "pietro.donatini@unibo.it"
      EXCEL_FIELDS.each do |field|
        row[field] = excel_line[@field2num[field]]
      end

      yield row
    end
  end

  private 

  # From headers line to symbol 
  # Corso di Studio => corso_di_studio
  def match_fields(line)
    res = Hash.new
    line.each_index do |i|
      key = line[i].downcase.gsub(' ', '_').to_sym
      # solo la seconda media_ponderata
      res[key] = i
    end
    res
  end

  def errore(row, reg = nil)
    raise UniboFileError, "errore nello studente #{row[@field2num[:email]]} nel campo=#{reg.to_s}"
  end

end

