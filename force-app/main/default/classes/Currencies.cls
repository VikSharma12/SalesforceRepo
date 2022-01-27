public class Currencies {
	
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getRates() {
        Map<String, Object> rates = new Map<String, Object>();
        
        HTTP h = new HTTP();
        HTTPRequest req = new HTTPRequest();
        
        req.setEndpoint('http://data.fixer.io/api/latest?access_key=7aea5a317de07d38c39644b6b35f2506&format=1');
        req.setMethod('GET');
        
        HTTPResponse res = h.send(req);
        
        Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());

        rates = (Map<String, Object>)m.get('rates');

        return rates;
    }
}