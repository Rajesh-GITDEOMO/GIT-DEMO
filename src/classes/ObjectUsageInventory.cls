Public class ObjectUsageInventory{

public String PROJECT_NAME = 'Tooling';
public String LOGIN_DOMAIN = 'login'; //other options: test, prerellogin.pre
public String USERNAME  = 'rajesh.jayapal@accenture.com';
public String PASSWORD  = 'October@23LU89BCcN5oRXcf2HpbNcpDUH';
public String SESSION_ID;  
public String SERVER_URL;


public void ExtractLimits() {
    EstablishConnection conn = new EstablishConnection(PROJECT_NAME,LOGIN_DOMAIN,USERNAME,PASSWORD);
    this.SESSION_ID = conn.SESSION_ID;
    this.SERVER_URL= conn.SERVER_URL;
    String baseUrl = this.SERVER_URL + '/services/data/v37.0/tooling/';
    string queryString = 'query/?q=SELECT+iscustomSetting,Description,DeveloperName,+DurableId,+QualifiedApiName,(SELECT+DurableId,EntityDefinitionId,Label,Max,Remaining,Type+FROM+LIMITS)+FROM+EntityDefinition+LIMIT+10';
    HTTPRequest req = new HTTPRequest();
    req.setEndpoint(baseUrl + queryString);
    req.setMethod('GET');
    // OAuth header 00D90000000mvw0!ARkAQA1_OluzzkXbsDwpxU8kg1Q9t9D5ytYbdDzrIWazZk.Jd1nEL80dAuTn2wYlghwFTCM5bEUb1zOHm7_YogObVMspzspQ
    //req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
    req.setHeader('Authorization', 'Bearer ' + this.SESSION_ID);
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