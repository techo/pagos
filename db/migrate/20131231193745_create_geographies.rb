class CreateGeographies < ActiveRecord::Migration
  def change
    create_table :geographies do |t|
      t.integer :village_id

      t.timestamps
    end
  end
end
