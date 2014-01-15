class HistoricalPaymentsReport

  attr_accessor :from, :to, :result

  def initialize
    @from = Date.today.beginning_of_month
    @to = Date.today
  end

  def generate
    @payments = Payment.within_range @from, @to
    @result = @payments.to_a.map(&:serializable_hash)
    include_columns

    cumulated_payments = get_initial_balance

    @result.each do |rp|
      rp["initial_balance"] = cumulated_payments[rp["family_id"]]
      cumulated_payments[rp["family_id"]] += rp["amount"]
      rp["final_balance"] = cumulated_payments[rp["family_id"]]
    end
  end

  private
  def include_columns
    @result.map{|record| 
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
