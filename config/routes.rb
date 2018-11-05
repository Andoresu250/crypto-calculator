Rails.application.routes.draw do
  
  
    scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ , defaults: {format: :json} do
        
        match 'calculators/calculate' => 'calculators#calculate', via: :post
        match 'calculators/currencies' => 'calculators#currencies', via: :get
        
    end
  
end
