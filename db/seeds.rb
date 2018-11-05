currencies_file = File.read('currencies.json')
currencies = JSON.parse(currencies_file)

currencies.each do |params|
    Currency.create(params)
end