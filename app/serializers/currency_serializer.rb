class CurrencySerializer < ActiveModel::Serializer
  attributes :id, :symbol, :name, :symbol_native, :decimal_digits, :rounding, :code, :name_plural

end