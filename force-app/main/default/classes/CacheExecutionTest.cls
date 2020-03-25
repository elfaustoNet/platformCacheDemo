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
}
