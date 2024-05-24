# Running Azure FHIR Server with Docker

*IMPORTANT:* This sample has been created to enable Dev/Test scenarios and is not suitable for production scenarios. Passwords are contained in deployment files, the SQL server connection is not encrypted, authentication on the FHIR Server has been disabled, and data is not persisted between container restarts.

The following instructions detail how to build and run the FHIR Server in Docker on Linux.

## Use CI image

If it is not desirable to clone this repository and build locally an image of the most recent CI build is available from the Microsoft Container Registry(mcr.microsoft.com/healthcareapis). Both of the following methods will generate a R4 server, but a STU3 or R5 server can be created by changing which image is pulled.


Using just docker this image can be started with the following steps. Replace the `<SA_PASSWORD>` below with your chosen SQL connection password, following the [SQL server password complexity requirements](https://docs.microsoft.com/en-us/sql/relational-databases/security/password-policy?view=sql-server-ver15#password-complexity)), from the root of the `microsoft/fhir-server` repository:
1. Open a terminal window.
2. Run the command: 

```bash
docker network create fhir_network
```

3. Run the command: 

```bash
docker run --net fhir_network --name fhir_sql -e SA_PASSWORD=$Env:SAPASSWORD -e ACCEPT_EULA="Y" -d mcr.microsoft.com/mssql/server
```

4. Give the SQL server a minute to start up.
5. Run the command: 

```bash
docker run --net fhir_network -e FhirServer__Security__Enabled="false" -e SqlServer__ConnectionString="Server=tcp:fhir_sql,1433;Initial Catalog=FHIR;Encrypt=false;TrustServerCertificate=true;User ID=sa;Password=$Env:SAPASSWORD;MultipleActiveResultSets=False;Connection Timeout=30;" -e SqlServer__AllowDatabaseCreation="true" -e SqlServer__Initialize="true" -e SqlServer__SchemaOptions__AutomaticUpdatesEnabled="true" -e DataStore="SqlServer" -p 8020:8080 -d mcr.microsoft.com/healthcareapis/r4-fhir-server azure-fhir-api
```

6. After giving the container a minute to start up it should be accessible at http://localhost:8080/metadata.


## Run in Docker with a custom configuration

To build the `azure-fhir-api` image run the following command from the root of the `microsoft/fhir-server`repository:

The default configuration builds an image with the FHIR R4 API:

```bash
docker build -f ./build/docker/Dockerfile -t azure-fhir-api --build-arg FHIR_VERSION=R4 .
```

For STU3 use the following command:

```bash
docker build -f build\docker\Dockerfile -t azure-fhir-api --build-arg FHIR_VERSION=R5 .
```nn

The container can then be run, specifying configuration details such as:

```bash
docker pull mcr.microsoft.com/healthcareapis/r4-fhir-server

docker run -d `
    -e FHIRServer__Security__Enabled="false" `
    -e SqlServer__ConnectionString="Server=tcp:.database.usgovcloudapi.net,1433;Initial Catalog=r4-fhir-server;Persist Security Info=False;User ID=fhirserver;Password=12=;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;" `
    -e SqlServer__AllowDatabaseCreation="true" `
    -e SqlServer__Initialize="true" `
    -e SqlServer__SchemaOptions__AutomaticUpdatesEnabled="true" `
    -e DataStore="SqlServer" `
    -p 8080:8080 `
    mcr.microsoft.com/healthcareapis/r4-fhir-server azure-fhir-api
```
```
docker commit 9e1a6a7882eb ahsvdhfhircr.azurecr.us/r4-fhir-server
az acr login -n ahsvdhfhircr.azurecr.us
docker push  ahsvdhfhircr.azurecr.us/r4-fhir-server

https://fhir-server.scm.azurewebsites.net/Env
```


```
docker run -d -p 8080:8080 ahsvdhfhircr.azurecr.us/r4-fhir-server azure-fhir-api
    
```
