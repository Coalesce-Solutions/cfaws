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


# SSM Parameter Store
# Adobe ColdFusion Helper Module

## What is it?
AWS Systems Manager Parameter Store provides secure, hierarchical storage for configuration data management and secrets management. You can store data such as passwords, database strings, Amazon Machine Image (AMI) IDs, and license codes as parameter values. You can store values as plain text or encrypted data.

## Why should I use it?
* Store environmental variables
* Reduce the configuration requirements for each environment, whether dev, staging, or production
* Audit log of access via CloudTrail
* Remove sensitive information from your codebase

## How do I set it up?
AWS Console, SSM Parameter Store

## Functions, objects and methods used in this module:

### (From parameters.cfm file)

getClient - Authenticate with AWS and return the connected client to the designated region

```haskell
mySSMComponent = createObject("modules.awsssm").getClient(region="us-east-1");
```


putParameter - Add a new parameter string to the parameter store

```haskell
mySSMComponent.putParameter("demoParameter", "This is my new parameter value - #now()#");
```

getParameter - Retrieve a parameter

```haskell
writeOutput(mySSMComponent.getParameter("demoParameter"));
```


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
* Achieve compliance


## How do I set it up?
AWS Console, Secrets Manager, Store a new secret.
Optional – Set up password rotation. Example use of this would be rotating your RDS (database) password and trigger a Lambda to update the ColdFusion datasource.

## Functions, objects and methods used in this module:

### (From secrets.cfm file) 

TODO

# Key Management Service
# Adobe ColdFusion Helper Module

## What is it?
AWS Key Management Service (AWS KMS) is a managed service that makes it easy for you to create and control the cryptographic keys that are used to protect your data.

## Why should I use it?
* Compliance Requirements 
* Access logs (AWS CloudTrail)
* Automate key rotation
* Options for high security encryption techniques 
* Using encryption context (which means when you encrypt with a certain value of encryption context, you must have the exact same encryption context to be able to decrypt)

## How do I set it up?
AWS Console, AWS Key Management Service

Set up key rotation. Enable automatic key rotation only for symmetrical encryption KMS keys in the AWS console


## Functions, objects and methods used in this module:

### (From the kms1.cfm file)

getClient - Authenticate with AWS and return the connected client to the designated region

```haskell
 myKMSComponent = createObject("modules.awskms").getClient(region="us-east-1");
```

encrypt - Encrypt a string using the provided key ARN

```haskell
cipherText = myKMSComponent.encrypt(encryptThisString, keyARN);
    writeOutput("Cipher Demo Text (KMS):<pre>" & EncodeForHTML(cipherText) & "</pre>");
```

decrypt - Decrypt a ciphertext (the key used is embedded in the ciphertext)

```haskell
    plaintext = myKMSComponent.decrypt(cipherText);
    writeOutput("Decrypted Demo Text (KMS):<pre>" & plaintext & "</pre>");
```


### (From the kms2.cfm file)

Create an encryption context to be used for encryption

```haskell
encryptionContextStruct = {"Tenant ID":"123", "Transaction ID":"345"};
```

generateDataKey - Create a key use to encrypt/decrypt locally on the server using the KMS key as the key-encrypting-key (KEK). Use the encrytion context data we created with operational data to further increase security. This returns a structure with two values, Plaintext (the generated key for immediate use) and Ciphertext (the KMS-encrypted version of the generated key for storage and future use)

```haskell
 // Generate the datakey using the key and context
    dataKeyStruct = myKMSComponent.generateDataKey(keyARN, encryptionContextStruct);
    writeOutput("Generated data key, received cipher and plaintext of new key. Plaintext of key:<pre>" & EncodeForHTML(dataKeyStruct.Plaintext) & "</pre>");
```

Encrypt the string using CF's built-in encrypt function

```haskell
cipherText_Local = encrypt(encryptThisString, datakeyStruct.Plaintext, "AES");
    writeOutput("Cipher Demo Text (Local):<pre>" & EncodeForHTML(cipherText_Local) & "</pre>");
```

decryptDataKey - Decrypt the KMS-encrypted data key

```haskell
   dkPlaintext = myKMSComponent.decryptDataKey(datakeyStruct.Ciphertext, encryptionContextStruct);
    writeOutput("Decrypted datakey (KMS using enc context):<pre>" & EncodeForHTML(dkPlaintext) & "</pre>");
```

Decrypt the ciphertext using the unencrypted data key

```haskell
    // Decrypt the string using CF's built-in decrypt function
    plaintext_Local = decrypt(cipherText_Local, dkPlaintext, "AES");
    writeOutput("Decrypted Demo Text (Local):<pre>" & plaintext_Local & "</pre>");
```

# AWS CloudWatch Custom Metrics
# Adobe ColdFusion Helper Module

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

### (From the metrics.cfm file)

getClient - Authenticate with AWS and return the connected client to the designated region

```haskell
 myKMSComponent = createObject("modules.awskms").getClient(region="us-east-1");
```

putMetric - put a metric into CloudWatch Metrics


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
