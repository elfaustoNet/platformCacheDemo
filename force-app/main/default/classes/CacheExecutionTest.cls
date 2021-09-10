@isTest
public with sharing class CacheExecutionTest {
    @isTest
    static void testMethod1() {
        Test.startTest();
        List<String> objN1 = CacheExecution.objectNames1;
        List<String> objN2 = CacheExecution.objectNames2;
        List<String> objN3 = CacheExecution.objectNames3;
        //CacheExecution.finalCacheTest(null);
        CacheExecution.CacheDemoWrapper results = CacheExecution.finalCacheTest();
        Test.stopTest();
        system.assert(results.retrieveTotalTime > 0);
    }

    @isTest
    static void testMethod2() {
        Test.startTest();
        List<String> objN1 = CacheExecution.objectNames1;
        List<String> objN2 = CacheExecution.objectNames2;
        List<String> objN3 = CacheExecution.objectNames3;
        CacheExecution.enableFullDescribeTest = true;
        //CacheExecution.finalCacheTest(null);
        //CachePartition__mdt cp = [select DeveloperName, Label, Partition_Prefix__c, Full_Describe__c from CachePartition__mdt where DeveloperName = 'DemoPartition' limit 1];
        //cp.Full_Describe__c = true;
        //update cp;
        CacheExecution.CacheDemoWrapper results = CacheExecution.finalCacheTest();
        Test.stopTest();
        system.assert(results.retrieveTotalTime > 0);
    }


    
}
