/*
AWS Simple Systems Manager - Parameter Store Component
This component implements the AWS Simple Systems Manager primary functions

Created By: Coalesce Solutions, LLC
The MIT License

Copyright 2022 Adobe Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

*/

component output="false" hint="A component to help communicate with the AWS Simple Systems Manager - Parameter Store"{
	// Build creates the Java class to interface with the SSM interface and returns an initialized version of it
    public any function getClient(string region) {
        local.tempClass = java {
            import com.amazonaws.services.simplesystemsmanagement.*;
            import com.amazonaws.services.simplesystemsmanagement.model.*;

            public class awsSsm {
                AWSSimpleSystemsManagement ssmClient;

                // Constructor takes the AWS Region as a parameter and authenticates with AWS
                public awsSsm(String Region) {
                    // Change this line if you need to change the method of authenticating with your IAM role/user
                    ssmClient = AWSSimpleSystemsManagementClientBuilder.standard().withRegion(Region).build();
                }

                // Get the contents of an AWS Parameter with the provided parameterName value
                public String getParameter(String parameterName) {
                    // Define the request with decryption enabled by default. This flag is ignored for non-encrypted strings
                    GetParameterRequest paramRequest = new GetParameterRequest()
                        .withName(parameterName)
                        .withWithDecryption(true);

                    // Submit request to get the parameter from AWS SSM
                    GetParameterResult getParameterResult = ssmClient.getParameter(paramRequest);

                    // Return the String contents of the parameter
                    return getParameterResult.getParameter().getValue();
                }

                // Add or replace the contents of an AWS Parameter
                public void putParameter(String parameterName, String parameterValue) {
                    // Create as a SecureString by default
                    PutParameterRequest paramRequest = new PutParameterRequest()
                        .withName(parameterName)
                        .withOverwrite(true)
                        .withType("SecureString") // String, SecureString, StringList
                        .withValue(parameterValue);

                    // Submit request to put the parameter in AWS SSM
                    PutParameterResult putParameterResult = ssmClient.putParameter(paramRequest);

                    return;
                }

                // Get the contents of an AWS Secrets Manager secret using the Parameter Store function
                // Secrets Manager secrets are accessible via the parameter store by utilizing the /aws/reference/secretsmanager/ prefix
                public String getSecret(String secretName) {
                    return getParameter("/aws/reference/secretsmanager/" + secretName);
                }
            }
        };

        // Initializing the class to the provided AWS Region and return the instantiated class object
        return local.tempClass.init(arguments.region);
    }
}