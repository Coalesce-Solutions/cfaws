<cfscript>
    // Fetch the authenticated client object
    myCWComponent = createObject("modules.awscloudwatch").getClient(region="us-east-1");

    // The below is built to send a sample amount of random values to CloudWatch
    demoMetricCount = floor(rand()*20+1);

    myAppName = "My Important App";
    myServiceName = "Outgoing Payments";
    myServiceTopic = "Payment Provider 1";
    myMetricName = "Request Time";

    for (i=0; i < demoMetricCount; i++) {
        // Put a random measurement into CloudWatch Metrics
        myCWComponent.putMetric(myAppName, myServiceName, myServiceTopic, "Request Time", rand()*10, "Seconds");
    }
    
    writeOutput("Added #demoMetricCount# metric measurements into CloudWatch");
</cfscript>