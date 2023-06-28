# IRIS FHIR Transcribe-Summarize-Export

## Build and run
1. Replace `<openai_api_key>` in [docker-compose.yml](docker-compose.yml) with a valid OpenAI key. This is used in the summarizing the voice notes feature.
2. Run below script to stop, build and start docker containers.
    ```
    ./scripts/rebuild.sh
    ```

## Important Links

1. UI - http://localhost:52773/talk2doc/index.html
2. Backend - http://localhost:52773/fhir/api/patient/all
3. FHIR server - http://localhost:52773/fhir/r4/Patient

## Test FHIR REST API

Find the full list of APIs in [postman collection](other/IRIS-FHIR-Talk2Doc.postman_collection.json).

Basic Auth credentials, username - `SuperUser`, password - `SYS`. Sample curl for one endpoint below.

```
curl --location 'http://localhost:52773/fhir/api/patient/all' \
--header 'Authorization: Basic U3VwZXJVc2VyOlNZUw=='
```


### Build and Run Frontend Vue app

```
npm install
npm run build
npm run serve
```

## IRIS commands
Uncomment `print(rows)` in [irisfhirclient](src/python/irisfhirclient.py) to view results
```
docker-compose exec iris iris session iris
do ##class(fhir.dc.FhirClient).GetResource("Patient")
do ##class(fhir.dc.FhirClient).GetPatientResources("Observation","1")
do ##class(fhir.dc.FhirClient).CreateDocumentForPatient(1, 3, "blablabla", "application/pdf")
```