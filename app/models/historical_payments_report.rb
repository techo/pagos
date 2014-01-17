class HistoricalPaymentsReport

  attr_accessor :from, :to

  def initialize
    @from = Date.today.beginning_of_month
    @to = Date.today
  end

  def generate
    @payments = Payment.within_range @from, @to
    @payments = @payments.where("volunteer_id is not null")
    cumulated_payments = get_initial_balance

    result.each do |payment|
      payment["initial_balance"] = cumulated_payments[payment["family_id"]]
      cumulated_payments[payment["family_id"]] += payment["amount"]
      payment["final_balance"] = cumulated_payments[payment["family_id"]]
    end
  end

  def result
    add_balance_to_payments(@payments.to_a.map(&:serializable_hash))
  end

  private
  def add_balance_to_payments(payments)
    payments.map{ |record|
      record.merge!("initial_balance"=>0)
      record.merge!("final_balance"=>0)
    }
  end

  def get_initial_balance
    balances = {}
    firstPayments = @payments.minimum(:date, :group => :family_id)

    firstPayments.each do |p|
      initial_balance = Payment.group(:family_id).where('family_id = ? and date < ? ', p[0], p[1]).sum(:amount)
      initial_balance = initial_balance!={}?initial_balance:{p[0]=>0};
      balances.merge!(initial_balance)
    end
    balances
  end
end
