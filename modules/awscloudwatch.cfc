/*
Amazon CloudWatch Metrics
This component implements the Amazon CloudWatch Metrics publish metrics function
https://docs.aws.amazon.com/AWSJavaSDK/latest/javadoc/index.html?com/amazonaws/services/cloudwatch/model/package-summary.html

Created By: Coalesce Solutions, LLC
The MIT License

Copyright 2022 Adobe Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

*/

component output="false" hint="A component to help communicate with the Amazon CloudWatch Metrics" {
	// getClient creates the Java class to interface with the SSM interface and returns an initialized version of it
    public any function getClient(string region) {
        local.tempClass = java {
            import com.amazonaws.services.cloudwatch.*;
            import com.amazonaws.services.cloudwatch.model.*;

            public class awsCloudwatch {
                AmazonCloudWatch cwClient;

                // Constructor takes the AWS Region as a parameter and authenticates with AWS
                public awsCloudwatch(String Region) {
                    // Change this line if you need to change the method of authenticating with your IAM role/user
                    cwClient = AmazonCloudWatchClientBuilder.standard().withRegion(Region).build();
                }

                // Push Metrics to CloudWatch
                // Valid values for metricUnit: Megabits, Terabits, Gigabits, Count, Bytes, Gigabytes, Gigabytes/Second, Kilobytes, Kilobits/Second, Terabytes, Terabits/Second, Bytes/Second, Percent, Megabytes, Megabits/Second, Milliseconds, Microseconds, Kilobytes/Second, Gigabits/Second, Megabytes/Second, Bits, Bits/Second, Count/Second, Seconds, Kilobits, Terabytes/Second, None
                // Suggestions: nameSpace=App Name, Dimension Name=Service name, Dim Value=Measurement Topic, Metric Name=Type of Measurement
                public void putMetric(String nameSpace, String dimensionName, String dimensionValue, String metricName, Double metricValue, String metricUnit) {
                    Dimension dimension = new Dimension()
                        .withName(dimensionName)
                        .withValue(dimensionValue);

                    MetricDatum datum = new MetricDatum()
                        .withDimensions(dimension)
                        .withMetricName(metricName)
                        .withUnit(metricUnit)
                        .withValue(metricValue);
                       
                    PutMetricDataRequest metricRequest = new PutMetricDataRequest()
                        .withNamespace(nameSpace) // required, must not start with "AWS/"
                        .withMetricData(datum);

                    // Submit request to push the metric value to CloudWatch
                    cwClient.putMetricData(metricRequest);

                    return;
                }
            }
        };

        // Initializing the class to the provided AWS Region and return the instantiated class object
        return local.tempClass.init(arguments.region);
    }
}