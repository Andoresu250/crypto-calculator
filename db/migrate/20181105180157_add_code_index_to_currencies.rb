class AddCodeIndexToCurrencies < ActiveRecord::Migration[5.2]
  def change
    add_index :currencies, :code
  end
end
