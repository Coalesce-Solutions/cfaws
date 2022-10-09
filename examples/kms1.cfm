<cfscript>
    // This KMS example demonstrates using the KMS client's encrypt and decrypt functions directly

    // Fetch the authenticated KMS client object
    myKMSComponent = createObject("modules.awskms").getClient(region="us-east-1");

    // Fetch the authenticated SSM client object to pull a parameter
    mySSMComponent = createObject("modules.awsssm").getClient(region="us-east-1");

    // Key ARN references the AWS KMS customer managed key we want to use for the encryption. Pulling from parameter store.
    keyARN = mySSMComponent.getParameter("myDemoKMSKey");
    // keyARN = "arn:aws:kms:us-east-1:123456789012:key/26ec599c-6cf1-43b1-9d9a-1234567890123"; // Example Key ARN

    encryptThisString = "The quick brown fox jumps over the lazy dog";

    writeOutput("Demo Text to Encrypt:<pre>" & encryptThisString & "</pre>");

    cipherText = myKMSComponent.encrypt(encryptThisString, keyARN);
    writeOutput("Cipher Demo Text (KMS):<pre>" & EncodeForHTML(cipherText) & "</pre>");

    plaintext = myKMSComponent.decrypt(cipherText);
    writeOutput("Decrypted Demo Text (KMS):<pre>" & plaintext & "</pre>");
</cfscript>