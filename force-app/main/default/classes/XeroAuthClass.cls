public with sharing class XeroAuthClass {
    public String authUrl { get; private set; }

    public XeroAuthClass() {
        authUrl = XeroOAuth2.getAuthorizationUrl();
        system.debug('authUrl' + authUrl);
    }

    public PageReference redirectToXero() {
        return new PageReference(authUrl);
    }

    public PageReference handleCallback() {
        String code = ApexPages.currentPage().getParameters().get('code');
        if (code != null) {
            XeroOAuth2.exchangeCodeForToken(code);
        }
        return null;  // You can redirect to another page or show a success message
    }


}