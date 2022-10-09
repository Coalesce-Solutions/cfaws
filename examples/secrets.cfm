<cfscript>
    // Fetch the authenticated client object
    mySSMComponent = createObject("modules.awsssm").getClient(region="us-east-1");

    // Pull and output the SuperSecret secret value
    writeOutput(mySSMComponent.getSecret("SuperSecret"));
</cfscript>