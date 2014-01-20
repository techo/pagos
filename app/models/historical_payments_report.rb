class HistoricalPaymentsReport

  attr_accessor :from, :to, :result

  def initialize
    @from = Date.today.beginning_of_month
    @to = Date.today
  end

  def generate
    @payments = Payment.has_volunteer.within_range @from, @to
    @result = @payments.to_a.map do |payment|
      payment.serializable_hash(:include => :volunteer)
    end

    add_balances_to_payments
    calculate_cumulative_payments
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
      payment["initial_balance"] = cumulative_payments[payment["family_id"]]
      cumulative_payments[payment["family_id"]] += payment["amount"]
      payment["final_balance"] = cumulative_payments[payment["family_id"]]
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
end
