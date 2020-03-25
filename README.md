# Platform Cache Demo

This library is to demonstrate how to leverage Platform Cache.  Platform Cache increases the speeed at which data is accessed in a transaction. There are two types of Platform Cache, session cache and org cache. 

The best type of data to cache is reused throughout a session, is not frequently changing, and expensive to retrieve. 

The example use case to demo today is accessing object and field metadata using sobject describes. Metadata doesn't change often and executing `Schema.describeSObjects(List<String> objNames)` and `Schema.getGlobalDescribe()` can be a very expensive with regards to consuming CPU time. 

This will demonstrate the potential time savings of storing this information in org cache.


## Setup
1. Execute the `orginit.sh` script which will build create the scratch org with Platform Cache enabled and install the sample code. 
2. Navigate to your user record, and enable "Cache Diagnostics" permission. This will allow you to the keys in a partition. 
![User Setting](/images/userSetting.png)
3. Navigate to Setup -> Platform Cache and click on the demoPartition name. 
Click the edit button and allocate 3 MB of the Platform Cache to org cache. Click save.

![Cache Allocation](/images/cacheAllocation.png)



## Execution 
1. From Setup -> Platform Cache -> demoPartition record, open the Org Cache Allocation Diagnostics in a separate tab. If this is the first time using the org, the contents will be empty. 
2. Navigate to the Cache Demo tab. When you first navigate to the page, you'll see two buttons an execute and clear view. Click the execute button. This can take ~10-15 seconds to run. When it's complete, you'll see data returned that's the total time of execution, the results, and whether cache was accessed. 
![Demo Results](/images/demoResults.png)
3. Navigate to the Org Cache Diagnostics view and refresh the page. You'll now see stats for the partition including usage and the key contents, size of the key value, and how many times that key has been access. 
![Diagnostics Page](/images/DiagnosticsPage.png)
4. Navigate back to the Cache Demo tab. Click Clear View. Click Execute. This time, the results should return in a much quicker time < 1 second. The cached accessed checkbox will also be checked.
5. Navigate back to the Org Cache Diagnostics view and refresh the page. You'll see the access count has increased and last access datetime changed.
