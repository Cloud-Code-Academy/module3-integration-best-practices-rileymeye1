public with sharing class ExchangeRateService {
    public class ExchangeRateServiceException extends Exception{}

    private static final String NAMED_CREDENTIAL = 'ExchangeRate_API';
    private static final String BASE_CURRENCY = 'USD';
    
    public static ExchangeRateWrapper getLatestRates() {
        Exchange_Rate_API_Setting__mdt exchangeRateApiSetting = Exchange_Rate_API_Setting__mdt.getInstance('ACTIVE');
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:' + NAMED_CREDENTIAL + exchangeRateApiSetting.API_Key__c + '/latest/' + BASE_CURRENCY);
        req.setMethod('GET');
        HttpResponse res = http.send(req);

        if (res.getStatusCode() >= 200 && res.getStatusCode() <= 299) {
            ExchangeRateWrapper newExchangeRate = ExchangeRateWrapper.parse(res.getBody());
            return newExchangeRate;
        } else if (res.getStatusCode() == 404) {
			throw new ExchangeRateServiceException('Error: Base Currency: ' + BASE_CURRENCY + ' Not Found.');
		} else if (res.getStatusCode() >= 500) {
			throw new ExchangeRateServiceException('Error: Server error occurred. Please try again later.');
		} else {
			throw new ExchangeRateServiceException('Error: Request failed. Status: ' + res.getStatusCode() + ' - ' + res.getStatus());
		}
    }
    
    public static List<Exchange_Rate__c> processRates(ExchangeRateWrapper rateData) {
        List<Exchange_Rate__c> exchangeRates = rateData.toExchangeRates();
        Schema.SObjectField externalId = Exchange_Rate__c.Fields.External_Id__c;
        Database.upsert(exchangeRates, externalId, AccessLevel.SYSTEM_MODE);
        return exchangeRates;
    }
    
    public static List<Exchange_Rate__c> updateExchangeRates() {
        ExchangeRateWrapper rateData = getLatestRates();
        List<Exchange_Rate__c> exchangeRates = processRates(rateData);
        return exchangeRates;
    }
}