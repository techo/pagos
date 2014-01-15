class AddVolunteerToPayment < ActiveRecord::Migration
  def change
    add_column :payments, :volunteer_id, :integer
  end
end
