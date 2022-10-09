/*
AWS Key Management Service
This component implements the Foundational AWS KMS functions

Created By: Coalesce Solutions, LLC
The MIT License

Copyright 2022 Adobe Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

*/

component output="false" hint="A component to help communicate with the AWS KMS"
{
	// getClient creates the Java class to interface with the SSM interface and returns an initialized version of it
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

                // Encrypt a string with all implemented parameters
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

                // Decrypt a ciphertext with all implemented parameters
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
                
                // Generate a data key to encrypt outside of the KMS client (all available parameters)
                public Map<String, String> generateDataKey(String keyARN, Map<String, String> encryptionContext, String keySpec)
                {
                    // Prepare the generated data key request
                    GenerateDataKeyRequest paramRequest = new GenerateDataKeyRequest()
                        .withKeyId(keyARN)
                        .withEncryptionContext(encryptionContext)
                        .withKeySpec("AES_256"); // let's default to strong value by default

                    if (encryptionContext != null)
                        paramRequest.setEncryptionContext(encryptionContext);

                    if (keySpec != null)
                        paramRequest.setKeySpec(keySpec);
                    else
                        paramRequest.setKeySpec("AES_256"); // let's default to strong value by default

                    GenerateDataKeyResult dkResult = kmsClient.generateDataKey(paramRequest);
                    Map<String, String> datakeyStruct = Map.of("Plaintext", base64Encode(dkResult.getPlaintext()), "Ciphertext", base64Encode(dkResult.getCiphertextBlob()));
                    // Map<String, String> datakeyStruct = Map.of("Plaintext", new String(dkResult.getPlaintext().array()), "CipherText", base64Encode(dkResult.getCiphertextBlob()));
                    // Return the new data key structure containing both the Plaintext of the key (to use) and the ciphertext of the key (to store)
                    return datakeyStruct;
                }

                // Encrypt a string (no encryptionContext)
                public String encrypt(String plaintext, String keyARN)
                {
                    return encrypt(plaintext, keyARN, null);
                }

                // Decrypt a ciphertext (no encryptionContext)
                public String decrypt(String cipherText)
                {
                    return decrypt(cipherText, null);
                }

                // Decrypt a ciphertext datakey (no encryptionContext)
                public String decryptDataKey(String cipherText)
                {
                    return decryptDataKey(cipherText, null);
                }

                // Generate a data key to encrypt outside of the KMS client (with no keySpec or encryptionContext)
                public Map<String, String> generateDataKey(String keyARN)
                {
                    return generateDataKey(keyARN, null, null);
                }

                // Generate a data key to encrypt outside of the KMS client (with no keySpec)
                public Map<String, String> generateDataKey(String keyARN, Map<String, String> encryptionContext)
                {
                    return generateDataKey(keyARN, encryptionContext, null);
                }

                /************ Private functions ************/
                /* Dealing with the headache of base64 encoding/decoding to keep the above code "easy" */

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
        
        // Initializing the class to the provided AWS Region and return the instantiated class object
        return local.tempClass.init(arguments.region);
    }
}