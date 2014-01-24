class AddDebtToPayment < ActiveRecord::Migration
  def change
    add_column :payments, :debt, :decimal, precision: 8, scala: 2
  end
end
