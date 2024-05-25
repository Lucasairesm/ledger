require "csv"
class ReportMailer < ApplicationMailer

    default from: 'from@example.com'

    def send_report(email, csv_file_path = nil)
        # nil esta deixando a variavel facultativo caso não tenha deixa ela nula
        @email = email
       
      attachments['report.csv'] = generate_csv
      mail(to: email, subject: 'Relatório de Associados')
    end

    private

    def generate_csv
      CSV.generate(headers: true) do |csv|
        # Adiciona cabeçalhos ao CSV
        csv << ["Nome", "Saldo",]  #"parametros" que podem ser alterados para termos mais informações
  
        # Adiciona linhas de dados ao CSV
        Person.order(:name).each do |person|
            csv << [person.name, person.balance] 
        end
      end
    end
end
