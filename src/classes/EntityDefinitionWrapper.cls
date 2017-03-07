public class EntityDefinitionWrapper{
    public Integer size;    //56
    public Integer totalSize;   //56
    public boolean done;
    public string queryLocator;
    public String entityTypeName;   //EntityDefinition
    public cls_records[] records;
 public class cls_records {
        public cls_attributes attributes;
        public boolean IsCustomSetting;
        public string Description;
        public string DeveloperName;
        public string DurableId;
        public string QualifiedApiName;
        public Entity_Limits Limits;
    }
 public class cls_attributes {
        public String type; //EntityLimit
        public String url;  ///services/data/v37.0/tooling/sobjects/EntityLimit/Contract.CustomFields
    }
 public class Entity_Limits {
        public Integer size;    //9
        public Integer totalSize;   //9
        public boolean done;
        public string queryLocator;
        public String entityTypeName;
        public entityLimitRecord[] records; 
    }
 public class entityLimitRecord {
        public cls_attributes attributes;
        public String DurableId;    //Contract.CustomFields
        public String EntityDefinitionId;   //Contract
        public String Label;    //Custom Fields
        public Integer Max;    
        public Integer Remaining;   //500
        public String Type; //CustomFields
    }
   /** public static EntityDefinitionWrapper parse(String json){
        return (EntityDefinitionWrapper) System.JSON.deserialize(json, EntityDefinitionWrapper.class);
    } **/
}