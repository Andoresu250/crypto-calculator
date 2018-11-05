class CreateCurrencies < ActiveRecord::Migration[5.2]
  def change
    create_table :currencies do |t|
      t.string :symbol
      t.string :name
      t.string :symbol_native
      t.integer :decimal_digits
      t.integer :rounding
      t.string :code
      t.string :name_plural

      t.timestamps
    end
  end
end
