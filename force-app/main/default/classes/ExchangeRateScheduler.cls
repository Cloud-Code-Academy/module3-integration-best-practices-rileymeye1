global class ExchangeRateScheduler implements Schedulable {

    global void execute(SchedulableContext sc) {
        try {
            List<Exchange_Rate__c> exchangeRates = ExchangeRateService.updateExchangeRates();
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
    }
}