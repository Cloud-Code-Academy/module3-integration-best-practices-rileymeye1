/**
 * @description Wrapper class to deserialize the JSON response from the Exchange Rate API
 * Students will implement the properties and methods to process the data
 */
public class ExchangeRateWrapper {
    // Sample response:{"base_code":"USD","time_last_update_unix":1740690001,"conversion_rates":{"EUR":0.9488,"GBP":0.8393,"JPY":136.57,...}}
    public String base_code;
    public String time_last_update_unix;
    public Map<String, Decimal> conversion_rates;
    
    /**
     * @description Converts the wrapper data to a list of Exchange_Rate__c records
     * @return List<Exchange_Rate__c> The list of exchange rate records
     */
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
    
    /**
     * @description Static method to parse the JSON response into the wrapper class
     * @param jsonResponse The JSON response from the API
     * @return ExchangeRateWrapper The parsed wrapper instance
     */
    public static ExchangeRateWrapper parse(String jsonResponse) {
        ExchangeRateWrapper newExchangeRate = (ExchangeRateWrapper) JSON.deserialize(jsonResponse, ExchangeRateWrapper.class);
        return newExchangeRate;
    }
}