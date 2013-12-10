class AddNombreAndAppelidoToUser < ActiveRecord::Migration
  def change
    add_column :users, :nombre, :string
    add_column :users, :appelido, :string
  end
end
