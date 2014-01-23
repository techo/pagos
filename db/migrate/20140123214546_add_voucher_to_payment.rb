class AddVoucherToPayment < ActiveRecord::Migration
  def change
    add_column :payments, :voucher, :string
  end
end
