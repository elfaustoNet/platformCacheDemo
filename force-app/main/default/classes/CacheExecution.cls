public with sharing class CacheExecution {
    public static List<String> objectNames1 = new List<String>{'Account', 'Contact','Opportunity', 'Task', 'Case', 'Product2', 'OpportunityLineItem','Lead','CaseTeamMember','User'};
    public static List<String> objectNames2 = new List<String>{'Account', 'Contact','Opportunity', 'Task', 'Case', 'Product2', 'OpportunityLineItem','Lead','CaseTeamMember','User', 'Contract','Pricebook2','Order', 'WorkOrder','WorkType','Asset','AccountContactRole','Campaign','Attachment','BusinessHours'};
    public static List<String> objectNames3 = new List<String>{'Account', 'Contact','Opportunity', 'Task', 'Case', 'Product2', 'OpportunityLineItem','Lead','CaseTeamMember','User',
            + 'Contract','Pricebook2','Order', 'WorkOrder','WorkType','Asset','AccountContactRole',  'Campaign','Attachment','BusinessHours',
            + 'AssetFeed', 'CampaignFeed', 'AccountFeed', 'CaseComment','ContactFeed', 'OpportunityFeed','CaseFeed', 'OrderFeed','OrderHistory','PricebookEntry',
            + 'Announcement','WorkFeedbackRequest','LeadFeed','Address','Calendar','Idea','ContentVersion','Goal',
            + 'WorkTypeGroupFeed','WorkTypeGroup', 'ProductConsumed'};

    public static boolean enableFullDescribeTest = false;

    @AuraEnabled
    public static CacheDemoWrapper finalCacheTest() {
        
        CachePartition__mdt partitionPrefix = getPartitionPrefix();
        if (partitionPrefix == null)
        {
            throw new AuraHandledException('Partition Prefix was not found');
        }
        String cacheKey = partitionPrefix.Partition_Prefix__c + 'ConfigList'; //'local.default.ConfigList' ;
        //String cacheKey = Label.partitionPrefix + 'ConfigList'; //'local.default.ConfigList' ;
        CacheDemoWrapper results = new CacheDemoWrapper();
        List<ObjectData> configList = new List<ObjectData>(); 
        Long startCacheTime = System.currentTimeMillis();
       // try {
        configList = (List<ObjectData>)Cache.Org.get(cacheKey);
        Long endCacheTime = System.currentTimeMillis();
        Long totalCacheTime = endCacheTime - startCacheTime;
        if (configList == null )
        {
           configList = new List<ObjectData>();
            Long startDescribeTime = System.currentTimeMillis();
            
            if(partitionPrefix.Full_Describe__c || (Test.isRunningTest() && enableFullDescribeTest))
            {
                /* This section executes a full global describe.*/ 
                Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
                for(Schema.SObjectType objectType : globalDescribe.values()) {
                Schema.DescribeSObjectResult objDescribe = objectType.getDescribe();
                List<FieldData> fieldDataList = new List<FieldData>();
                for(Schema.SObjectField fieldType : objDescribe.fields.getMap().values()) {
                    Schema.DescribeFieldResult fieldDescribe = fieldType.getDescribe();
                    FieldData fd = new FieldData();
                        fd.fieldName = fieldDescribe.getName();
                        fd.fieldLabel = fieldDescribe.getLabel();
                        fd.fieldType = fieldDescribe.getType().name();
                        fieldDataList.add(fd);
                    }
                // do it twice to cause error
                for(Schema.SObjectField fieldType : objDescribe.fields.getMap().values()) {
                    Schema.DescribeFieldResult fieldDescribe = fieldType.getDescribe();
                    FieldData fd = new FieldData();
                        fd.fieldName = fieldDescribe.getName();
                        fd.fieldLabel = fieldDescribe.getLabel();
                        fd.fieldType = fieldDescribe.getType().name();
                        fieldDataList.add(fd);
                    }
                    ObjectData configToCache = new ObjectData();
                    configToCache.objectName = objDescribe.getName();
                    configToCache.objectLabel = objDescribe.getLabel();
                    configToCache.fieldProperties = JSON.serialize(fieldDataList);
                    configList.add(configToCache);
                }
            /* End global describe */
            
            }
            else {
                /* This section is to execute only list of object names */
                List<Schema.DescribeSobjectResult> objDescribeList = Schema.describeSObjects(objectNames1);
                for (Schema.DescribeSObjectResult r : objDescribeList) {
                    List<FieldData> fieldDataList = new List<FieldData>();
                    for(Schema.SObjectField fieldType : r.fields.getMap().values()) {
                        Schema.DescribeFieldResult fieldDescribe = fieldType.getDescribe();
                        FieldData fd = new FieldData();
                        fd.fieldName = fieldDescribe.getName();
                        fd.fieldLabel = fieldDescribe.getLabel();
                        fd.fieldType = fieldDescribe.getType().name();
                        fieldDataList.add(fd);
                    }
                    ObjectData od  = new ObjectData();
                    od.objectName = r.getName();
                    od.objectLabel = r.getLabel();
                    od.fieldProperties = JSON.serialize(fieldDataList);
                    configList.add(od);

                }
            /* End describe sobject List */
            

           
            }
            system.debug('configlist $$ ' + configList.size());
            Long endDescribeTime = System.currentTimeMillis();
            Long totalDescribeTime = endDescribeTime - startDescribeTime;
            system.debug('totalDescribeTime $$ ' + totalDescribeTime);
            Long startCacheInsertTime = System.currentTimeMillis();
            Cache.Org.put(cacheKey, configList);
            Long endCacheInsertTime = System.currentTimeMillis();
            Long totalCacheInsertTime = endCacheInsertTime - startCacheInsertTime;
            system.debug('total cache insert time $$ ' + totalCacheInsertTime);

            results.cacheAccessed = false;
            results.retrieveStartTime =  startDescribeTime;
            results.retrieveEndTime = endDescribeTime;
            results.retrieveTotalTime = totalDescribeTime;
        }
        else {
            results.cacheAccessed = true;
            results.retrieveStartTime = startCacheTime;
            results.retrieveEndTime = endCacheTime;
            results.retrieveTotalTime = totalCacheTime;
        }

        results.details = configList;
    //}catch(exception ex) {
    //        system.debug('exception ' + ex.getMessage() + ' ' + ex.getCause()  + ' ' + ex.getTypeName());
    //  }
        return results;
    }


    private static CachePartition__mdt getPartitionPrefix() {
        List<CachePartition__mdt> partitionRecords = new List<CachePartition__mdt>();
        partitionRecords = [select MasterLabel, DeveloperName, Full_Describe__c, Partition_Prefix__c from CachePartition__mdt where DeveloperName = 'DemoPartition' limit 1];
        system.debug('partitionRecords $$ ' + partitionRecords);
        if (!partitionRecords.isEmpty())
        {
            return partitionRecords[0];
        }
        else {
            return null;
        }
    }


    public class CacheDemoWrapper {
        @AuraEnabled
        public boolean cacheAccessed;
        @AuraEnabled
        public Long retrieveStartTime;
        @AuraEnabled
        public Long retrieveEndTime;
        @AuraEnabled
        public Long retrieveTotalTime;
        @AuraEnabled
        public List<ObjectData> details;
    }

    public class ObjectData implements Comparable {
        @AuraEnabled
        public  String objectName;  //key is the apiname
        @AuraEnabled
        public  String objectLabel; // value is the label
        @AuraEnabled 
        public String fieldProperties;

        public Integer compareTo(Object compareTo) {
            ObjectData compareToObject = (ObjectData)compareTo;
            Integer returnValue = 0;
            if(objectLabel > compareToObject.objectLabel) {
                returnValue = 1;
            }
                else if (objectLabel < compareToObject.objectLabel) {
                    returnValue = -1;
            }
            return returnValue;
        }

    }

    public class fieldData { 
        @AuraEnabled
        public String fieldName;
        @AuraEnabled
        public String fieldLabel;
        @AuraEnabled
        public String fieldType;
            
    }

}
