public class OrgInfo_XmlStreamReader {

 

public String org{get;set;}

public List<String> XMLData{get;set;}

 

public OrgInfo_XmlStreamReader(){

XMLData=new List<String>();

 

}

 

public List<String> getOrganisationInfo(String ip){ 

Http http = new Http();

HttpRequest req = new HttpRequest();

req.setEndpoint('http://xml.utrace.de/?query='+ip);

req.setMethod('GET');

HttpResponse res = http.send(req);

 

// Log the XML content

String xmlContent=res.getBody();

System.debug(res.getBody());

System.debug('#####XmlStreamReader ##11##');

// Generate the HTTP response as an XML stream

 

XmlStreamReader reader = res.getXmlStreamReader();

System.debug('##########XML DATA##########'+res.getXmlStreamReader());

 

XMLData=XMLParser(res.getBody());

return XMLData;

}

 

public List<String> XMLParser(String strXml){

System.debug('####Inside XMLParser Method########'+strXml);

List<String> orgInfo=new List<String>();

Dom.Document doc = new Dom.Document();
system.debug('****doc***'+doc);

doc.load(strXml);
system.debug('****docload***'+doc);
//Retrieve the root element for this document.

Dom.XMLNode Envelope = doc.getRootElement();
system.debug('****Envelope***'+Envelope );
Dom.XMLNode Body= Envelope.getChildElements()[0];
system.debug('****Body***'+Body);
string user_createResult = '';

 

for(Dom.XMLNode child : Body.getChildElements()) {

orgInfo.add(child .getText());
system.debug('****getChildren***'+child .getChildren());
system.debug('****getName***'+child .getName());
system.debug('****childText***'+child .getText());

}

return orgInfo;

}

}