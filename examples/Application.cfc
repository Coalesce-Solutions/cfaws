component {
    this.name = "awssdkDemo";
    this.mappings = structNew();
    this.mappings["/modules"] = ExpandPath("../modules");
    // Load the AWS SDK using the Java Loader
    this.javaSettings	= {LoadPaths =["./awssdk/"], reloadOnChange = true};
}
