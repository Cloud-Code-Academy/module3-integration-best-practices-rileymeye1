public class ExchangeRateWrapper {
    // Sample Response:{"base_code":"USD","time_last_update_unix":1740690001,"conversion_rates":{"EUR":0.9488,"GBP":0.8393,"JPY":136.57,...}}
    public String base_code;
    public String time_last_update_unix;
    public Map<String, Decimal> conversion_rates;
    
    public List<Exchange_Rate__c> toExchangeRates() {
        List<Exchange_Rate__c> exchangeRates = new List<Exchange_Rate__c>();
        for (String targetCurrency : conversion_rates.keySet()) {
            exchangeRates.add(new Exchange_Rate__c(
                Name = this.base_code + '_' + targetCurrency,
                Base_Currency__c = this.base_code,
                Target_Currency__c = targetCurrency,
                Rate__c = conversion_rates.get(targetCurrency),
                External_Id__c = this.base_code + '_' + targetCurrency,
                Last_Updated__c = Datetime.newInstance(Integer.valueof(time_last_update_unix))
            ));
        }
        return exchangeRates;
    }
    
    public static ExchangeRateWrapper parse(String jsonResponse) {
        ExchangeRateWrapper newExchangeRate = (ExchangeRateWrapper) JSON.deserialize(jsonResponse, ExchangeRateWrapper.class);
        return newExchangeRate;
    }
}