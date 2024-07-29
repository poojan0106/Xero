public class XeroTokenManager {
    public static void storeTokens(String accessToken, String refreshToken) {
        Xero_Setup__c tokenRecord = new Xero_Setup__c();
        tokenRecord.Access_Token__c = accessToken;
        tokenRecord.Refresh_Token__c = refreshToken;
        insert tokenRecord;
    }
    
    public static Xero_Setup__c getToken() {
        List<Xero_Setup__c> tokens = [SELECT Access_Token__c, Refresh_Token__c FROM Xero_Setup__c LIMIT 1];
        if (tokens.isEmpty()) {
            return null;
        }
        return tokens[0];
    }
    
    public static void updateAccessToken(String newAccessToken) {
        Xero_Setup__c tokenRecord = getToken();
        if (tokenRecord != null) {
            tokenRecord.Access_Token__c = newAccessToken;
            update tokenRecord;
        }
    }
}