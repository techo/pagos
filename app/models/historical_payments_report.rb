require "csv"

class HistoricalPaymentsReport
  COLUMNS = ["Comunidad", "Familia", "Fecha", "Saldo Inicial", "Abono", "Saldo Final", "Efectivo o Comprobante", "Registrado por"]
  FIELDS = [:geography, :family_head, :date, :initial_balance, :amount, :final_balance, :receipt, :volunteer]
  attr_accessor :from, :to, :result

  def initialize
    @from = Date.today.beginning_of_month
    @to = Date.today
  end

  def generate
    @payments = Payment.has_volunteer.within_range @from, @to
    @result = @payments.to_a.map do |payment|
      volunteer = payment.volunteer.full_name
      payment.serializable_hash.merge!("volunteer"=>volunteer, 
                                       "receipt"=>payment.deposit_number||"EFECTIVO",
                                       "initial_balance"=>payment.debt+payment.amount,
                                       "final_balance"=>payment.debt)
    end

    add_pilote_info
  end

  def to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << COLUMNS
      @result.each do |payment|
        row = []
        FIELDS.each do |field|
          row << payment[field.to_s]
        end
        csv << row
      end
    end
  end

  private
  def add_pilote_info
    families = @payments.pluck(:family_id).uniq
    families_details = PiloteHelper.get_families_details families
    @result.each do |payment|
      family_details = families_details.detect{|f| f["id_de_familia"] == payment["family_id"].to_s}
      payment.merge!("family_head"=>family_details["jefe_de_familia"])
      payment.merge!("geography"=>"#{family_details["provincia"]} - #{family_details["ciudad"]} - #{family_details["asentamiento"]}")
      payment.merge!("original_cost"=>family_details["monto_original"])
    end
    sort_results
  end

  def sort_results
    @result.sort_by! do |record|
      [record["geography"], record["family_head"], record["date"]]
    end
  end
end
