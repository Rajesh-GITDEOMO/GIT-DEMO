public class fromJSON{
    public Integer size;    //1348
    public Integer totalSize;   //1348
    public boolean done;
    public cls_queryLocator queryLocator;
    public String entityTypeName;   //EntityDefinition
    public cls_records[] records;
    class cls_queryLocator {
    }
    class cls_records {
        public cls_attributes attributes;
        public boolean IsCustomSetting;
        public String QualifiedApiName; //Contract
    }
    class cls_attributes {
        public String type; //EntityDefinition
        public String url;  ///services/data/v37.0/tooling/sobjects/EntityDefinition/Contract
    }
    public static fromJSON parse(String json){
        return (fromJSON) System.JSON.deserialize(json, fromJSON.class);
    }
}