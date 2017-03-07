public with sharing class MetaController {
    
    public static void createRemoteSiteSettings(string sessionId ,string fullName , string url , string description,Boolean isActive,Boolean disableProtocolSecurity)
    {   
        MetadataService.MetadataPort service = createService(sessionId,url);
        MetadataService.RemoteSiteSetting remoteSiteSettings = new MetadataService.RemoteSiteSetting();
        remoteSiteSettings.fullName = fullName; //'Test12345'
        remoteSiteSettings.url = url; // 'http://www.google.com'
        remoteSiteSettings.description= description;   //'ewf'
        remoteSiteSettings.isActive= isActive;    //true;
        remoteSiteSettings.disableProtocolSecurity= disableProtocolSecurity; //false
        MetadataService.AsyncResult[] results = service.create(new List<MetadataService.Metadata> { remoteSiteSettings });
        MetadataService.AsyncResult[] checkResults = service.checkStatus(new List<string> {string.ValueOf(results[0].Id)});
        system.debug('chk' + checkResults );
    }
    public static MetadataService.MetadataPort createService(string sessionId , string url)
    {
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
       // service.endpoint_x = 'https://login.salesforce.com'+ '/services/Soap/m/27.0';
        service.SessionHeader.sessionId = sessionId;
        return service;
    }
}