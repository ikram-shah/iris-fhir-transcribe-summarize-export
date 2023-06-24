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
--header 'Authorization: Basic U3VwZXJVc2VyOlNZUw==' \
--header 'Cookie: CSPSESSIONID-SP-32783-UP-fhir-api-=006000000000UJ3gJ4P9SPaW83TIG7l10zzUYAYBJquyO913L7; CSPWSERVERID=hA0TLhQP'
```

### UI build

```
npm run build
```