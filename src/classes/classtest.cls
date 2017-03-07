/** Code change to push local Repository : Master  to Remote Repository : Master **/

Public class classtest{
// Class variable for Tooling API base URL
// you'll need to add the base URL as a Remote Site in the org
private static String baseUrl = URL.getSalesforceBaseUrl().toExternalForm() 
    + '/services/data/v28.0/tooling/';

public static void createClass() {
    // Note the escaping on newlines and quotes
    String classBody = 'public class MyNewClass {\\n'
        + ' public string SayHello() {\\n'
        + '  return \'Hello\';\\n' 
        + ' }\\n'
        + '}';

    HTTPRequest req = new HTTPRequest();
    req.setEndpoint(baseUrl + 'sobjects/ApexClass');
    req.setMethod('POST');
    // OAuth header
    req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
    req.setHeader('Content-Type', 'application/json');
    req.setBody('{'+
        '"Body" : "' + classBody +'"'+
    '}');

    Http h = new Http();
    HttpResponse res = h.send(req);
    // Response to a create should be 201
    if (res.getStatusCode() != 201) {
        System.debug(res.getBody());
        //throw new MyException(res.getStatus());
    }
}
}