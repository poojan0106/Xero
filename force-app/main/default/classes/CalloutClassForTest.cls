public class CalloutClassForTest {
	public static HttpResponse getInfoFromExternalService() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://in.xero.com/jTvXx4DDVr9KVzIVTyhtnlNkUXYJ94zyMMXs4aSY/Invoice/DownloadPdf/39aab3da-5ee1-4435-82d3-254e6bc68a9d');
        req.setMethod('GET');
        Http h = new Http();
        HttpResponse res = h.send(req);
        return res;
    }
}