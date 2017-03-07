Public class EntityTest{
// Class variable for Tooling API base URL
// you'll need to add the base URL as a Remote Site in the org
private static String baseUrl = URL.getSalesforceBaseUrl().toExternalForm() 
    + '/services/data/v37.0/tooling/';
    public static List<object> ttt{get;set;}
/**public EntityTest(){
ttt = new List<object>();
createClass();
}**/

public static void createClass() {
    string queryString = 'SELECT+iscustomSetting,DurableId,QualifiedApiName+FROM+EntityDefinition+WHERE+iscustomSetting=false';
    HTTPRequest req = new HTTPRequest();
    req.setEndpoint(baseUrl + 'query/?q='+ queryString);
   // req.setEndpoint(baseUrl + 'sobjects/');
    req.setMethod('GET');
    // OAuth header
    req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
    req.setHeader('Content-Type', 'application/json');
    
    Http h = new Http();
    HttpResponse res = h.send(req);
    // Response to a create should be 201
   // if (res.getStatusCode() == 200) {
        //System.debug(res.getBody());
        system.debug('****'+res.getBody());
        //JSON2Apex obj = JSON2Apex.parse(res.getBody());
        //string s =res.getBody();
        fromJSON obj = fromJSON.parse(res.getBody());
       // ttt =r.records;
        system.debug('***'+obj.records);
        //throw new MyException(res.getStatus());
    //}
}
}