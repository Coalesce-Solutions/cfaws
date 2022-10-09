<cfscript>
    // Fetch the authenticated client object
    mySSMComponent = createObject("modules.awsssm").getClient(region="us-east-1");

    // Add/replace a parameter called demoParameter
    mySSMComponent.putParameter("demoParameter", "This is my new parameter value - #now()#");

    // Pull and output the demoParameter value
    writeOutput(mySSMComponent.getParameter("demoParameter"));
</cfscript>