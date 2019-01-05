class CalculatorsController < ApplicationController
    
    def currencies
        currencies = Currency.all
        render json: currencies, status: :ok
    end
    
    def calculate
        value = params[:value]
        btc = params[:btc]
        currency = params[:currency]
        
        return renderJson(:unprocessable, {error: "value o btc no esta presente"}) unless value || btc 
        
        return renderJson(:not_found, {error: "Esta moneda no es valida"}) if currency.nil? || !(@currency = Currency.find_by(code: currency.upcase))
        
        if btc
            
            url = 'https://blockchain.info/ticker'
            response = RestClient.get url
            
            return renderJson(:unprocessable, {error: "Ha ocurrido un error intente mas tarde"}) unless response.code == 200
            body = JSON.parse(response.body)
            btc_value = body['USD']['last'].to_f
            
            value = btc_value * btc
            
            
            unless @currency.code == 'USD'
                # api_currency_params = {
                #     access_key: ENV['currencylayer_api_key'],
                #     from: @currency.code,
                #     to: 'USD',
                #     format: 1
                # }
                # response = RestClient.get 'http://apilayer.net/api/convert', {params: api_currency_params}
                # body = JSON.parse(response.body)
                # return renderJson(:unprocessable, {error: "No se pudo hacer la conversion de #{@currency.code} a USD"}) unless body['success'] # value = body['result']
                
                response = RestClient.get "http://www.apilayer.net/api/live?access_key=#{ENV['currencylayer_api_key']}"
                body = JSON.parse(response.body)
                return renderJson(:unprocessable, {error: "No se pudo hacer la conversion de #{@currency.code} a USD"}) unless body['success']
                usd_to_currency = body['quotes']["USD#{@currency.code}"].to_f
                value = value * usd_to_currency
                
            end
            
            json = {
                btc: btc.to_f,
                currency: @currency.code,
                symbol: @currency.symbol,
                value: value
            }
            renderJson(:ok, json)
            
        else
            unless @currency.code == 'USD'
                # api_currency_params = {
                #     access_key: ENV['currencylayer_api_key'],
                #     from: @currency.code,
                #     to: 'USD',
                #     format: 1
                # }
                # response = RestClient.get 'http://apilayer.net/api/convert', {params: api_currency_params}
                # body = JSON.parse(response.body)
                # return renderJson(:unprocessable, {error: "No se pudo hacer la conversion de #{@currency.code} a USD"}) unless body['success'] # value = body['result']
                
                response = RestClient.get "http://www.apilayer.net/api/live?access_key=#{ENV['currencylayer_api_key']}"
                body = JSON.parse(response.body)
                return renderJson(:unprocessable, {error: "No se pudo hacer la conversion de #{@currency.code} a USD"}) unless body['success']
                usd_to_currency = body['quotes']["USD#{@currency.code}"].to_f
                value = value/usd_to_currency
                
            end
            
            url = "https://blockchain.info/tobtc?currency=USD&value=#{value}"
            response = RestClient.get url
            
            if response.code == 200
                json = {
                    btc: response.body.to_f,
                    currency: @currency.code,
                    symbol: @currency.symbol,
                    value: value
                }
                renderJson(:ok, json)
            else
                renderJson(:unprocessable, {error: "Ha ocurrido un error intente mas tarde"})
            end
        end
    end
    
end
