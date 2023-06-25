## Build and run

```
./rebuild.sh
```

## Links

1. UI - http://localhost:52773/ui/dist/index.html
2. Backend - http://localhost:52773/fhir/api/patient/all
3. FHIR server - http://localhost:52773/fhir/r4/Patient

## Test FHIR rest api

Auth header is basic auth. Username - SuperUser, Password - SYS

```
curl --location 'http://localhost:52773/fhir/api/patient/all' \
--header 'Authorization: Basic U3VwZXJVc2VyOlNZUw=='
```

### Build UI

```
npm run build
```

## IRIS commands
Uncomment `print(rows)` in [irisfhirclient](src/python/irisfhirclient.py) to view results
```
docker-compose exec iris iris session iris
do ##class(fhir.dc.FhirClient).GetResource("Patient")
do ##class(fhir.dc.FhirClient).GetPatientResources("Observation","a5b737fb-1f94-4767-802b-1112051f5101")
```