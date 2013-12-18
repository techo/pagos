class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :family_id
      t.decimal :amount, :precision => 8, :scale => 2
      t.datetime :date
    end
  end
end
