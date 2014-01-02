class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.references :volunteer, index: true
      t.references :geography, index: true

      t.timestamps
    end
  end
end
