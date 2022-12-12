<p align="center">
	<img src="https://i1.wp.com/coalescesolutions.com/wp-content/uploads/2021/01/Coalesce_Solutions_vertical_logo.png" height="125">
	<br>
</p>

<p align="center">
	Copyright 2022 Coalesce Solutions
	<br>
	<a href="https://www.coalescesolutions.com">www.coalescesolutions.com</a>
</p>


# Adobe ColdFusion - AWS SDK Helper Modules

## Prerequisites - AWS SDK and Credentials

1) Sign up for AWS Account
https://portal.aws.amazon.com/billing/signup

2) Create IAM User Account or Role with access to AWS services
https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html

3. Download the latest AWS SDK (version 1) from [https://sdk-for-java.amazonwebservices.com/latest/aws-java-sdk.zip](https://sdk-for-java.amazonwebservices.com/latest/aws-java-sdk.zip). These modules will not work with version 2 of the AWS SDK, as it requires using Maven to build the necessary components and thus adds a decent amount of complexity towards getting started with the SDK. It is recommended, however, to use Maven if you intend to run your ColdFusion application in Lambda to reduce your application storage and memory size.

4. Create the Role or User account in AWS Identity and Access Management (IAM) to be utilized by the ColdFusion service. It is highly recommended to follow the [principal of least privilege](https://en.wikipedia.org/wiki/Principle_of_least_privilege) when assigning access rights to your ColdFusion service. See [https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html) for more information.

## Installing the SDK for use by ColdFusion

The helper modules all use the ColdFusion 2021 feature [cfjava](https://helpx.adobe.com/uk/coldfusion/cfml-reference/coldfusion-tags/tags-j-l/cfjava.html) 

Here are the steps required to install the SDK:

1. Extract the SDK zip file to a temporary location
2. Copy the SDK's lib/aws-java-sdk-#.##.####.jar to \<CF install folder\>/cfusion/lib
3. Copy the contents of the SDK's third-party/lib/ folder to \<CF install folder\>/cfusion/lib
4. [Re]start ColdFusion

## Using your IAM User / Role in ColdFusion

In order for ColdFusion to interact with any AWS service via the SDK, you will need your application to be able to authenticate as an IAM User or IAM Role.

See [https://docs.aws.amazon.com/sdk-for-java/v1/developer-guide/credentials.html#credentials-default](https://docs.aws.amazon.com/sdk-for-java/v1/developer-guide/credentials.html#credentials-default) for how the SDK attempts to find the AWS credentials.

Below, we will go over a few of the most common or preferred methods of using the credentials to access AWS resources. You may notice none of the examples below tell you to use the access key and secret key directly in your code – this is done on purpose to help prevent you from inadvertently sharing your credentials with others.

### Access Option 1: Instance Role / Task Role / Execution Role

This is, by far, the easiest and most efficient way of authenticating. Whether you are running ColdFusion on an Amazon EC2 Instance, ECS task, or Lambda, the SDK can access the Role that is assigned to the compute resource. If you have assigned a role to your instance/task, then the SDK will automatically be able to utilize that role.

See [https://docs.aws.amazon.com/IAM/latest/UserGuide/id\_roles\_use\_switch-role-ec2\_instance-profiles.html](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2_instance-profiles.html) for details.

### Access Option 2: Java system properties

In \<CF install folder\>/cfusion/bin/jvm.config\> or in the ColdFusion Administrator under Server Settings-\>Java and JVM, you will need to add the following to your JVM arguments:

-Daws.accessKeyId=\<your access key\> -Daws.secretKey=\<your secret key\>

### Access Option 3: Using the default credentials file

If your ColdFusion service is running as a designated user account in the operating system (as it should), then your credentials can be stored in \<user account's home folder\>/.aws/credentials (actual location may vary by operating system). See [https://docs.aws.amazon.com/sdk-for-java/v1/developer-guide/credentials.html#credentials-file-format](https://docs.aws.amazon.com/sdk-for-java/v1/developer-guide/credentials.html#credentials-file-format) or [https://docs.aws.amazon.com/sdk-for-java/v1/developer-guide/setup-credentials.html#setup-credentials-setting](https://docs.aws.amazon.com/sdk-for-java/v1/developer-guide/setup-credentials.html#setup-credentials-setting) for details.

### Access Option 4: Environment Variables

Create environment variables for AWS\_ACCESS\_KEY\_ID and AWS\_SECRET\_ACCESS\_KEY

See [https://docs.aws.amazon.com/sdk-for-java/v1/developer-guide/setup-credentials.html#setup-credentials-setting](https://docs.aws.amazon.com/sdk-for-java/v1/developer-guide/setup-credentials.html#setup-credentials-setting) for details.



# Secrets Manager
# Adobe ColdFusion Helper Module

## Prerequisites
* Check out https://github.com/brianklaas/ctlS3Utils for code format, SDK setup, notes, etc
AWS Credential Options
* See https://docs.aws.amazon.com/sdk-for-java/v1/developer-guide/credentials.html#credentials-default for how the SDK attempts to find the AWS credentials.

## What is it?
AWS Secrets Manager enables you to replace hardcoded credentials in your code, including passwords, with an API call to Secrets Manager to retrieve the secret programmatically

## Why should I use it?
* Don’t ever store your credentials (or other confidential information) in your code
* Reduce the configuration requirements for each environment, whether dev, staging, or production
* Automate password rotation
* Audit log of retrieving secret via CloudTrail


## How do I set it up?
AWS Console, Secrets Manager, Store a new secret
Optional – Set up password rotation. Example use of this would be rotating your RDS (database) password and trigger a Lambda to update the ColdFusion datasource.

## Functions, objects and methods used in this module:

### (From secrets.cfm file) 

Fetched the authenticated client object using the createObject object that takes in the awsssm client parameter and stores the secret in the mySSMComponent variable


# SSM Parameter Store
# Adobe ColdFusion Helper Module

## Prerequisites
See Module 0 for configuring the SDK.

## What is it?
AWS Systems Manager Parameter Store provides secure, hierarchical storage for configuration data management and secrets management. You can store data such as passwords, database strings, Amazon Machine Image (AMI) IDs, and license codes as parameter values. You can store values as plain text or encrypted data.

## Why should I use it?
* Store environmental variables
* Reduce the configuration requirements for each environment, whether dev, staging, or production
* Audit log of access via CloudTrail

## How do I set it up?
AWS Console, SSM Parameter Store screenshots

## Functions, objects and methods used in this module:

### (From parameters.cfm file)

Used the createObject object to fetch the authenticated object

```haskell
mySSMComponent = createObject("modules.awsssm").getClient(region="us-east-1");
```


Added string method "putParameter" to store the value of the mySSMComponent object

```haskell
mySSMComponent.putParameter("demoParameter", "This is my new parameter value - #now()#");
```

Used getParameter within a writeOutput function to output the stored value

```haskell
writeOutput(mySSMComponent.getParameter("demoParameter"));
```

### (From awsssm.cfc file)


The getClient constructor creates the Java class to interface with the SSM interface and returns an initialized version of it

```haskell
 public any function getClient(string region) {
        local.tempClass = java {
            import com.amazonaws.services.simplesystemsmanagement.*;
            import com.amazonaws.services.simplesystemsmanagement.model.*;
```

Created the class awsSsm and put the ssmClient constructor takes the AWS Region as a parameter and authenticates with AWS
Authenticating the ssmClient using the AWSSimpleSystemsManagementClientBuilder with your IAM role/User

```haskell
public class awsSsm {
                AWSSimpleSystemsManagement ssmClient;

                // Constructor takes the AWS Region as a parameter and authenticates with AWS
                public awsSsm(String Region) {
                    // Change this line if you need to change the method of authenticating with your IAM role/user
                    ssmClient = AWSSimpleSystemsManagementClientBuilder.standard().withRegion(Region).build();
                }
```


Get the contents of an AWS Parameter with the provided parameterName value using the function getParameter
Creating an instance of a object GetParameterRequest Define the request with decryption enabled by default

```haskell
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
```

Creating an instance of a class putParameter to Add or replace the contents of an AWS Parameter
Create as a SecureString by default with the instance of a class of PutParameterRequest with attibutes passed

```haskell
  public void putParameter(String parameterName, String parameterValue) {
                    // Create as a SecureString by default
                    PutParameterRequest paramRequest = new PutParameterRequest()
                        .withName(parameterName)
                        .withOverwrite(true)
                        .withType("SecureString") // String, SecureString, StringList
                        .withValue(parameterValue);
```

Submit request to put the parameter in AWS SSM

```haskell
PutParameterResult putParameterResult = ssmClient.putParameter(paramRequest);

                    return;
                }
```
with the getSecret function Get the contents of an AWS Secrets Manager secret using the Parameter Store function

```haskell
public String getSecret(String secretName) {
                    return getParameter("/aws/reference/secretsmanager/" + secretName);
                }
            }
        };
```

# Key Management Service
# Adobe ColdFusion Helper Module

## Prerequisites
Check out https://github.com/brianklaas/ctlS3Utils for code format, SDK setup, notes, etc

AWS Credential Options

See https://docs.aws.amazon.com/sdk-for-java/v1/developer-guide/credentials.html#credentials-default for how the SDK attempts to find the AWS credentials.

## What is it?
AWS Key Management Service (AWS KMS) is a managed service that makes it easy for you to create and control the cryptographic keys that are used to protect your data.

## Why should I use it?
* Compliance Requirements 
* Access logs (AWS CloudTrail)
* Automate key rotation
* Options for high security encryption techniques 
* Using encryption context (which means when you encrypt with a certain value of encryption context, you must have the exact same encryption context to be able to decrypt)

## How do I set it up?
AWS Console, AWS Key Management Service screenshots

Set up key rotation. Enable automatic key rotation only for symmetrical encryption KMS keys in the AWS console

Can be done using this AWS CLI command:

aws kms enable-key-rotation --key-id 1234abcd-12ab-34cd-56ef-1234567890ab


## Functions, objects and methods used in this module:

### (From the awskms.cfc file) 

The getClient constructor creates the Java class to interface with the SSM interface and returns an initialized version of it
Created the class kmsClient and put the awsKms constructor takes the AWS Region as a parameter and authethicates with AWS
Authenticating the kmsClient using the AWSKMSClientBuilder with your IAM role/User

```haskell
public any function getClient(string region)
    {
        local.tempClass = java
        {
            import com.amazonaws.services.kms.*;
            import com.amazonaws.services.kms.model.*;
            import java.nio.charset.StandardCharsets;
            import java.nio.ByteBuffer;
            import java.util.Base64;
            import java.util.Map;

            public class awsKms
            {
                AWSKMS kmsClient;

                // Constructor takes the AWS Region as a parameter and authenticates with AWS
                public awsKms(String Region)
                {
                    // Change this line if you need to change the method of authenticating with your IAM role/user
                    kmsClient = AWSKMSClientBuilder.standard().withRegion(Region).build();
                }
```

Encrpyted a string using encrypt function with all the implemented parameters
Used the generateDataKey class with AWS resources as parameters to generate a data key to encrypt outside of the KMS client

Encrpyted a string with the encrypt function passing the plaintext, keyARN parameters

```haskell
 public String encrypt(String plaintext, String keyARN, Map<String, String> encryptionContext)
                {
                    // Prepare the encryption request
                    EncryptRequest paramRequest = new EncryptRequest()
                        .withKeyId(keyARN)
                        .withPlaintext(ByteBuffer.wrap(plaintext.getBytes(StandardCharsets.UTF_8)));

                    if (encryptionContext != null)
                        paramRequest.setEncryptionContext(encryptionContext);

                    // Encrypt value and return base64-encoded ciphertext string
                    return doEncrypt(paramRequest);
                }
```

Decrypted a ciphertext with the decrypt function with the parameter ciphertext and encrpytion context passed to it

Using the doDecrypt function for the decrpytion

```haskell
 public String decrypt(String ciphertext, Map<String, String> encryptionContext)
                {
                    // Prepare the decryption request
                    DecryptRequest paramRequest = new DecryptRequest()
                        .withCiphertextBlob(base64Decode(ciphertext));

                    if (encryptionContext != null)
                        paramRequest.setEncryptionContext(encryptionContext);

                    // Decrypt value
                    return doDecrypt(paramRequest, false);
                }

                // Decrypt a ciphertext with all implemented parameters
                public String decryptDataKey(String ciphertext, Map<String, String> encryptionContext)
                {
                    // Prepare the decryption request
                    DecryptRequest paramRequest = new DecryptRequest()
                        .withCiphertextBlob(base64Decode(ciphertext));

                    if (encryptionContext != null)
                        paramRequest.setEncryptionContext(encryptionContext);

                    // Decrypt value
                    return doDecrypt(paramRequest, true);
                }
```

Using the doEncrypt function for the encryption

Using base64Encode function with the plaintext parameter password to do the base64 encoding

```haskell
 // Do the actual encryption
                private String doEncrypt(EncryptRequest encRequest)
                {
                    // Return the Base64-formatted String of the encrypted ciphertext
                    return base64Encode(kmsClient.encrypt(encRequest).getCiphertextBlob());
                }

                // Do the actual decryption
                private String doDecrypt(DecryptRequest decRequest, Boolean isDataKey)
                {
                    // If we are decrypting a datakey, then we need to encode the results as Base64 since it is a binary value encrypted instead of string
                    if (isDataKey)
                        return base64Encode(kmsClient.decrypt(decRequest).getPlaintext());
                    else
                        return new String(kmsClient.decrypt(decRequest).getPlaintext().array(), StandardCharsets.UTF_8);
                }

                // When encoding a String, the end goal in all scenarios is a ByteBuffer
                private ByteBuffer base64Encode(String plaintext)
                {
                    return Base64.getEncoder().encode(ByteBuffer.wrap(plaintext.getBytes(StandardCharsets.UTF_8)));
                }

                // When encoding a ByteBuffer, the end goal in all scenarios is a String
                private String base64Encode(ByteBuffer plainByteBuffer)
                {
                    return new String(Base64.getEncoder().encode(plainByteBuffer.array()), StandardCharsets.UTF_8);
                }
```

Using base64Decode function with the plaintext parameter password to do the base64 decoding

```haskell
// When decoding a String, the end goal in all scenarios is a ByteBuffer
                private ByteBuffer base64Decode(String encodedString)
                {
                    return Base64.getDecoder().decode(ByteBuffer.wrap(encodedString.getBytes(StandardCharsets.UTF_8)));
                }

                // When decoding a ByteBuffer, the end goal in all scenarios is a String
                private String base64Decode(ByteBuffer encodedByteBuffer)
                {
                    return new String(Base64.getDecoder().decode(encodedByteBuffer.array()), StandardCharsets.UTF_8);
                }
               
            }
        };
```

### (From the km1.cfm file)

Created the mySSMComponent to fetch the authenticated SSM object to pull a parameter

```haskell
 myKMSComponent = createObject("modules.awskms").getClient(region="us-east-1");

    // Fetch the authenticated SSM client object to pull a parameter
    mySSMComponent = createObject("modules.awsssm").getClient(region="us-east-1");
```

Initialized the keyARN variable to reference the customer managed key to store the plaintext value that would pull from KMS
```haskell
 keyARN = mySSMComponent.getParameter("myDemoKMSKey");
```

Passing the plain text values "The quick brown fox jumps over the lazy dog" into the encrpytthisString variable that will be encrypted using the cipherText variable within the mySSMComponent variable

```haskell
 encryptThisString = "The quick brown fox jumps over the lazy dog";

 writeOutput("Demo Text to Encrypt:<pre>" & encryptThisString & "</pre>");
 ```

Then it will be decrypted using the decrypt function and uses the EncodeForHTML to encode an input string to store the parameter

Then storing the decrpyt function to output the decoded string 

```haskell
cipherText = myKMSComponent.encrypt(encryptThisString, keyARN);
    writeOutput("Cipher Demo Text (KMS):<pre>" & EncodeForHTML(cipherText) & "</pre>");

    plaintext = myKMSComponent.decrypt(cipherText);
    writeOutput("Decrypted Demo Text (KMS):<pre>" & plaintext & "</pre>");
```


### (From the kms2.cfm file)

Created the mySSMComponent to fetch the authenticated SSM object to pull a parameter
```haskell
 myKMSComponent = createObject("modules.awskms").getClient(region="us-east-1");

    // Fetch the authenticated SSM client object to pull a parameter
    mySSMComponent = createObject("modules.awsssm").getClient(region="us-east-1");
```

Initialized the keyARN variable to reference the customer managed key to store the plaintext value that would pull from parameter store

Passing the plain text values "The quick brown fox jumps over the lazy dog" into the encrpytthisString variable that will be encrypted using the cipherText variable within the mySSMComponent variable

```haskell
keyARN = mySSMComponent.getParameter("myDemoKMSKey");
    // keyARN = "arn:aws:kms:us-east-1:123456789012:key/26ec599c-6cf1-43b1-9d9a-1234567890123"; // Example Key ARN

    encryptThisString = "The quick brown fox jumps over the lazy dog";
```

Using the encryptionContextStruct variable to store plaintext values to encrypt

```haskell
encryptionContextStruct = {"Tenant ID":"123", "Transaction ID":"345"};
```

Using the dataKeyStruct that contains the generateDataKey function that has the keyARN and encrpytionContextStruct passed as parameters

```haskell
 // Generate the datakey using the key and context
    dataKeyStruct = myKMSComponent.generateDataKey(keyARN, encryptionContextStruct);
    writeOutput("Generated data key, received cipher and plaintext of new key. Plaintext of key:<pre>" & EncodeForHTML(dataKeyStruct.Plaintext) & "</pre>");
```

Encrypting the string using CF's built-in encrypt function within the cipherText_Local variable

```haskell
cipherText_Local = encrypt(encryptThisString, datakeyStruct.Plaintext, "AES");
    writeOutput("Cipher Demo Text (Local):<pre>" & EncodeForHTML(cipherText_Local) & "</pre>");
```

Decrypting the datakey using the same encrpytion context that was used during generating the datakey inside the dkPlainText variable and outputing it using writeOutput function 

```haskell
   dkPlaintext = myKMSComponent.decryptDataKey(datakeyStruct.Ciphertext, encryptionContextStruct);
    writeOutput("Decrypted datakey (KMS using enc context):<pre>" & EncodeForHTML(dkPlaintext) & "</pre>");

    // Decrypt the string using CF's built-in decrypt function
    plaintext_Local = decrypt(cipherText_Local, dkPlaintext, "AES");
    writeOutput("Decrypted Demo Text (Local):<pre>" & plaintext_Local & "</pre>");
```

# AWS CloudWatch Custom Metrics
# Adobe ColdFusion Helper Module

## Prerequisites
Check out https://github.com/brianklaas/ctlS3Utils for code format, SDK setup, notes, etc

AWS Credential Options

See https://docs.aws.amazon.com/sdk-for-java/v1/developer-guide/credentials.html#credentials-default for how the SDK attempts to find the AWS credentials.

## What is it?
Introduce AWS CloudWatch Custom Metrics

## Why should I use it?
* Track system load
* Send operational signals
* Configure metric-based alarms

## How do I set it up?
AWS Console, AWS CloudWatch screenshots


## Functions, objects and methods used in this module:

### (From the awscloudwatch.cfc file)

The getClient constructor creates the Java class to interface with the SSM interface and returns an initialized version of it

awsCloudwatch Constructor takes the AWS Region as a parameter and authenticates with AWS

Using the AmazonCloudWatchClientBuilder as the method of authenticating with your IAM role/User stored in the cwClient variable

```haskell
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
```

Using the putMetric function with various parameters such as dimensionValue and dimensionName stored

Creating a new instance of the Dimension class with attributes such as the dimensionName and dimensionValue included

Creating a new instance of the MetricDatum class with attributes such as dimension, metricName, metricUnit, and metricValue

Creating a new instance of the PutMetricDataRequest class with attributes nameSpace and datum contained

The cwClient variable submits the request to push the metric value to CloudWatch

```haskell
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
```


### (From the metrics.cfm file)

Fetched the authenticated client object using the createObject object that takes in the awscloudwatch client parameter and stores the secret in the mySSMComponent variable

```haskell
myCWComponent = createObject("modules.awscloudwatch").getClient(region="us-east-1");
```

The demoMetricCount varaible sends a sample amount of random values to CloudWatch

```haskell
 demoMetricCount = floor(rand()*20+1);

    myAppName = "My Important App";
    myServiceName = "Outgoing Payments";
    myServiceTopic = "Payment Provider 1";
    myMetricName = "Request Time";

    for (i=0; i < demoMetricCount; i++) {
        // Put a random measurement into CloudWatch Metrics
        myCWComponent.putMetric(myAppName, myServiceName, myServiceTopic, "Request Time", rand()*10, "Seconds");
    }
    
```

Outputing the metric measurements into CloudWatch with the writeOutput function

```haskell
 writeOutput("Added #demoMetricCount# metric measurements into CloudWatch");
```



