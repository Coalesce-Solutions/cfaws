# Adobe ColdFusion - AWS SDK Helper Modules

## Prerequisites - AWS SDK and Credentials

### For these examples to work, you must copy the aws sdk and the relevant jar files inside this folder

1) Sign up for AWS Account
https://portal.aws.amazon.com/billing/signup

2) Create IAM User Account or Role with access to AWS services
https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html

3. Download the latest AWS SDK (version 1) from [https://sdk-for-java.amazonwebservices.com/latest/aws-java-sdk.zip](https://sdk-for-java.amazonwebservices.com/latest/aws-java-sdk.zip). We will not be using version 2 of the AWS SDK, as it requires using Maven to build the necessary components and thus adds a decent amount of complexity towards getting started with the SDK. It is recommended, however, to use Maven if you intend to run your ColdFusion application in Lambda to reduce your application storage and memory size.

4. Create the Role or User account in AWS Identity and Access Management (IAM) to be utilized by the ColdFusion service. It is highly recommended to follow the [principal of least privilege](https://en.wikipedia.org/wiki/Principle_of_least_privilege) when assigning access rights to your ColdFusion service. See [https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html) for more information.

## Installing the SDK for use by ColdFusion

The helper modules all use the ColdFusion 2021 feature [cfjava](https://helpx.adobe.com/uk/coldfusion/cfml-reference/coldfusion-tags/tags-j-l/cfjava.html) 

Here are the steps required to install the SDK:

1. Extract the SDK zip file to a temporary location
2. Copy the SDK's lib/aws-java-sdk-#.##.####.jar to \<CF install folder\>/cfusion/lib
3. Copy the contents of the SDK's third-party/lib/ folder to \<CF install folder\>/cfusion/lib
4. [Re]start ColdFusion