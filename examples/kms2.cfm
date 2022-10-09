<cfscript>
    // This KMS example demonstrates using a datakey generated from KMS along with an encryption context

    // Fetch the authenticated KMS client object
    myKMSComponent = createObject("modules.awskms").getClient(region="us-east-1");

    // Fetch the authenticated SSM client object to pull a parameter
    mySSMComponent = createObject("modules.awsssm").getClient(region="us-east-1");

    // Key ARN references the AWS KMS customer managed key we want to use for the encryption. Pulling from parameter store.
    keyARN = mySSMComponent.getParameter("myDemoKMSKey");
    // keyARN = "arn:aws:kms:us-east-1:123456789012:key/26ec599c-6cf1-43b1-9d9a-1234567890123"; // Example Key ARN

    encryptThisString = "The quick brown fox jumps over the lazy dog";
   
    // Build the encryption context structure. 
    // Fill this with something that applies to your operations that you can rebuild later based on your own data
    encryptionContextStruct = {"Tenant ID":"123", "Transaction ID":"345"};

    // Generate the datakey using the key and context
    dataKeyStruct = myKMSComponent.generateDataKey(keyARN, encryptionContextStruct);
    writeOutput("Generated data key, received cipher and plaintext of new key. Plaintext of key:<pre>" & EncodeForHTML(dataKeyStruct.Plaintext) & "</pre>");
    
    // Encrypt string using CF's built-in encrypt function
    cipherText_Local = encrypt(encryptThisString, datakeyStruct.Plaintext, "AES");
    writeOutput("Cipher Demo Text (Local):<pre>" & EncodeForHTML(cipherText_Local) & "</pre>");

    // To decrypt, we are acting like we do not have the datakey's plaintext.
    // Instead, all we have is the ciphertext of the datakey that we need to decrypt in order to use

    // Decrypt the datakey using the same encryption context that was used during generating the datakey.
    dkPlaintext = myKMSComponent.decryptDataKey(datakeyStruct.Ciphertext, encryptionContextStruct);
    writeOutput("Decrypted datakey (KMS using enc context):<pre>" & EncodeForHTML(dkPlaintext) & "</pre>");

    // Decrypt the string using CF's built-in decrypt function
    plaintext_Local = decrypt(cipherText_Local, dkPlaintext, "AES");
    writeOutput("Decrypted Demo Text (Local):<pre>" & plaintext_Local & "</pre>");
</cfscript>