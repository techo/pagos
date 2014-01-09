class AddDepositNumberToPayment < ActiveRecord::Migration
  def change
    add_column :payments, :deposit_number, :string, length: 50
  end
end
