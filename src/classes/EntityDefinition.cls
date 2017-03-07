Public class EntityDefinition{
// Class variable for Tooling API base URL
// you'll need to add the base URL as a Remote Site in the org
//private static String baseUrl = URL.getSalesforceBaseUrl().toExternalForm() 
 //   + '/services/data/v37.0/tooling/';
public String SESSION_ID;  
public String SERVER_URL; 
public void getSessionId(){
final String LOGIN_DOMAIN = 'monsanto-us--uscozkt.cs59.my'; //other options: test, prerellogin.pre
final String USERNAME  = 'praveen.kumara55cf@cognizant.com';
final String PASSWORD  = 'Saratha@2349';

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

}
    
public void ExtractLimits() {
    getSessionId();
    String baseUrl = SERVER_URL + '/services/data/v37.0/tooling/';
    string queryString = 'query/?q=SELECT+iscustomSetting,Description,DeveloperName,+DurableId,+QualifiedApiName,(SELECT+DurableId,EntityDefinitionId,Label,Max,Remaining,Type+FROM+LIMITS)+FROM+EntityDefinition';
    HTTPRequest req = new HTTPRequest();
    req.setEndpoint(baseUrl + queryString);
    req.setMethod('GET');
    // OAuth header 00D90000000mvw0!ARkAQA1_OluzzkXbsDwpxU8kg1Q9t9D5ytYbdDzrIWazZk.Jd1nEL80dAuTn2wYlghwFTCM5bEUb1zOHm7_YogObVMspzspQ
    //req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
    req.setHeader('Authorization', 'Bearer ' + SESSION_ID);
    req.setHeader('Content-Type', 'application/json');
    
    Http h = new Http();
    HttpResponse res = h.send(req);
    // Response to a create should be 201
   // if (res.getStatusCode() == 200) {
            String jsonString = '[' ;
                jsonString += res.getBody();
                jsonString += ']';
            system.debug('****'+res.getBody());
            system.debug('****'+jsonString);
            List<EntityDefinitionWrapper> entityDefList;
           entityDefList = (List<EntityDefinitionWrapper>) JSON.deserialize(jsonString , List<EntityDefinitionWrapper>.class);
            system.debug('***entityDefList'+entityDefList);
            EntityDefinitionList(entityDefList); 
         /**  EntityDefinitionWrapper obj = EntityDefinitionWrapper.parse(res.getBody());
            system.debug('***'+obj);
            system.debug('***'+obj.records);**/
         /**   for(integer i = 0 ; i < obj.records.size() ; i++){
                system.debug('***'+obj.records[i].IsCustomSetting); 
                system.debug('***'+obj.records[i].DurableId);
                system.debug('***'+obj.records[i].QualifiedApiName);
                for(integer j = 0 ; j < obj.records[i].ent_limits.size() ; j++){
                system.debug('***'+obj.records[i].ent_limits[j].entityTypeName);
                    for(integer k = 0 ; k < obj.records[i].ent_limits[j].entityLimitRecords.size() ; k++){
                        system.debug('***'+obj.records[i].ent_limits[j].entityLimitRecords[k].Label);
                        system.debug('***'+obj.records[i].ent_limits[j].entityLimitRecords[k].Remaining);
                        system.debug('***'+obj.records[i].ent_limits[j].entityLimitRecords[k].Type);
                        system.debug('***'+obj.records[i].ent_limits[j].entityLimitRecords[k].EntityDefinitionId);
                        
                    }
                } 
            }  ***/
       //}
}
Map<string,Boolean> customSettingIdentificationMap = new Map<string,Boolean>();
Map<string,string> objectIdNameMap = new Map<string,string>();
Map<string,Map<string,Integer>> objectLimitsMap = new Map<string,Map<string,Integer>>();
Set<string> limitsNameList =  new Set<string>();
public void EntityDefinitionList(List<EntityDefinitionWrapper> entityDefList){
    for(EntityDefinitionWrapper entDef : entityDefList){
        if(!entDef.records.isEmpty()){
            for(EntityDefinitionWrapper.cls_records rec : entDef.records){
                customSettingIdentificationMap.put(rec.DurableId,rec.IsCustomSetting);
                objectIdNameMap.put(rec.DurableId,rec.QualifiedApiName);
                if(!rec.Limits.records.isEmpty()){
                    for(EntityDefinitionWrapper.entityLimitRecord limrec : rec.Limits.records){
                        if(objectLimitsMap.containsKey(limrec.EntityDefinitionId)){
                            objectLimitsMap.get(limrec.EntityDefinitionId).put(limrec.Label,limrec.Max-limrec.Remaining);
                            limitsNameList.add(limrec.Label);
                        }else{
                            Map<string,Integer> LimitType =  new Map<string,Integer>();
                            LimitType.put(limrec.Label,limrec.Max-limrec.Remaining);   
                            objectLimitsMap.put(limrec.EntityDefinitionId,LimitType);
                            limitsNameList.add(limrec.Label);
                        }
                    }
                }
            }
        }
    }system.debug('***objectLimitsMap'+objectLimitsMap);
exportToExcel();    
}


Public void exportToExcel(){
  String allRows ='';
    List<string> header = new List<string>{'Object Name','Object Id'};
    for(string s : limitsNameList){
        header.add(s);
    }
    header.add('Is Custom Setting');
    allRows = string.join(header,',');
    allRows = allRows + '\n';
    for(String s :objectIdNameMap.keySet()){
        allRows = allRows + objectIdNameMap.get(s);
        allRows = allRows + ',' + s;
        for(string l : limitsNameList){
            allRows = allRows + ',' + objectLimitsMap.get(s).get(l);
        }
        allRows = allRows + ',' + customSettingIdentificationMap.get(s) + '\n';
        system.debug('****allRows'+allRows);
    }
    sendEmail(allRows);
}

public void sendEmail(String allRows){
    Messaging.EmailFileAttachment csvAttachment = new Messaging.EmailFileAttachment();
    Blob csvBlob = blob.valueOf(allRows);
    String csvName = 'Object Limits.csv';
    csvAttachment.setFileName(csvName);
    csvAttachment.setBody(csvBlob);
    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
    String[] toAddresses = new String[]{'rajesindian@gmail.com'};
    String subject = 'Object Limits';
    email.setSubject(subject);
    email.setToAddresses(toAddresses);
    email.setPlainTextBody('Object Limits');
    email.setFileAttachments(new Messaging.EmailFileAttachment[] {csvAttachment});
    Messaging.SendEmailResult[] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
}
}