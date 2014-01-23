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
      payment.serializable_hash.merge!("volunteer"=>volunteer, "receipt"=>payment.deposit_number||"EFECTIVO")
    end

    add_balances_to_payments
    add_pilote_info
    calculate_cumulative_payments
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
  def add_balances_to_payments
    @result.map{ |record|
      record.merge!("initial_balance"=>0)
      record.merge!("final_balance"=>0)
    }
  end

  def calculate_cumulative_payments
    cumulative_payments = get_initial_balance

    @result.each do |payment|
      payment["initial_balance"] = payment["original_cost"].to_f - cumulative_payments[payment["family_id"]]
      cumulative_payments[payment["family_id"]] += payment["amount"]
      payment["final_balance"] =  payment["original_cost"].to_f - cumulative_payments[payment["family_id"]]
    end
  end

  def get_initial_balance
    balances = {}
    firstPayments = @payments.group(:family_id).minimum(:date)

    firstPayments.each do |p|
      initial_balance = Payment.group(:family_id).where('family_id = ? and date < ? ', p[0], p[1]).sum(:amount)
      initial_balance = initial_balance!={}?initial_balance:{p[0]=>0};
      balances.merge!(initial_balance)
    end
    balances
  end

  def add_pilote_info
    families = @payments.pluck(:family_id)
    families_details = PiloteHelper.get_families_details families
    @result.each do |payment|
      family_details = families_details.detect{|f| f["id_de_familia"] == payment["family_id"].to_s}
      payment.merge!("family_head"=>family_details["jefe_de_familia"])
      payment.merge!("geography"=>family_details["asentamiento"])
      payment.merge!("original_cost"=>family_details["monto_original"])
    end
  end
end
