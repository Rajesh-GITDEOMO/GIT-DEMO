Public class EstablishConnection{
public String SESSION_ID;  
public String SERVER_URL;
public String PROJECT_NAME;
public String LOGIN_DOMAIN;
public String USERNAME;
public String PASSWORD;


public EstablishConnection(string PROJECT_NAME,string LOGIN_DOMAIN,string USERNAME,string PASSWORD){
this.PROJECT_NAME = PROJECT_NAME;
this.LOGIN_DOMAIN = LOGIN_DOMAIN;
this.USERNAME = USERNAME;
this.PASSWORD = PASSWORD;
getServerSessionId();
}
 
public void getServerSessionId(){
//final String LOGIN_DOMAIN = 'monsanto-us--uscozkt.cs59.my'; //other options: test, prerellogin.pre
//final String USERNAME  = 'praveen.kumara55cf@cognizant.com';
//final String PASSWORD  = 'Saratha@2349';

HttpRequest request = new HttpRequest();
request.setEndpoint('https://' + LOGIN_DOMAIN + '.salesforce.com/services/Soap/u/22.0');
request.setMethod('POST');
request.setHeader('Content-Type', 'text/xml;charset=UTF-8');
request.setHeader('SOAPAction', '""');
request.setBody('<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/"><Header/><Body><login xmlns="urn:partner.soap.sforce.com"><username>' + USERNAME + '</username><password>' + PASSWORD + '</password></login></Body></Envelope>');
Dom.XmlNode resultElmt = (new Http()).send(request).getBodyDocument().getRootElement()
  .getChildElement('Body','http://schemas.xmlsoap.org/soap/envelope/')
  .getChildElement('loginResponse','urn:partner.soap.sforce.com')
  .getChildElement('result','urn:partner.soap.sforce.com');

SERVER_URL = resultElmt.getChildElement('serverUrl','urn:partner.soap.sforce.com').getText().split('/services')[0];
SESSION_ID = resultElmt.getChildElement('sessionId','urn:partner.soap.sforce.com').getText();
system.debug(SESSION_ID);

MetaController.createRemoteSiteSettings(SESSION_ID,PROJECT_NAME,SERVER_URL,'Org analysis',true,false);

}

}