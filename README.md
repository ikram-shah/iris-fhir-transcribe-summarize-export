# IRIS FHIR Transcribe-Summarize-Export

Built by [Ikram Shah](https://community.intersystems.com/user/ikram-shah) and [Sowmiya Nagarajan](https://community.intersystems.com/user/sowmiya-nagarajan).

## Overview

This is a full-stack application that allows practitioners and other clinicians to record voice notes linked to a subject and also export them to Google Docs. 
1. The UI enables voice recording and the audio is transcribed to text using **Open AI Whisper API**. 
2. Then the notes are summarized using **Open AI LLM** models and stored as **Document References** in FHIR server. 
3. Finally, there is an option to export the stored documents to **Google Docs** in an account of user's choice.

The application also acts as a dashboard to view patient and other information like observations, encounters in a 

The frontend UI is built as a **Vue.js** app. The backend is powered by **IRIS REST** api and there is an underlying FHIR server running to store all data. The application uses **embedded-python** to connect to FHIR api via fhirpy module.

## Build and run
1. Replace `<openai_api_key>` in [docker-compose.yml](docker-compose.yml) with a valid OpenAI key. This is used in the summarizing the voice notes feature.
2. Follow steps in to configure OAuth Client ID for Google docs export. Set it in [.env](src/vue/.env)
3. Run below script to stop, build and start docker containers.
    ```bash
    ./scripts/rebuild.sh
    ```

## Configure Google OAuth Client ID
> ⚠️ *Not all users can test the OAuth flow (for Google Docs export) due to restrictions in the consent screen during testing phase with Google. You need to set up your own client ID and use it as mentioned below. This is a quick process and should only take a few minutes.  **But feel free to also raise an issue in this repo to add specific mail IDs to test quickly.*** ⚠️

<br/>

1. Follow steps [here](https://support.google.com/cloud/answer/6158849?hl=en#zippy=%2Cweb-applications) to create a OAuth consent screen and client ID for a test project.
2. Add scope required for docs export - `https://www.googleapis.com/auth/documents`
3. Configure authorized javascript origin and authorized redirect URI as `http://localhost:8080` or whichever port you run the frontend vue app on.
4. Add some test user email IDs to allow testing. Only these users can authorize via the OAuth flow. If you need to open it up for more users, then a mandatory review process is required. More details [here](https://support.google.com/cloud/answer/10311615?hl=en).
5. Set the obtained client ID in [.env](src/vue/.env)

## Useful Links

1. UI - [http://localhost:8080](http://localhost:8080)
2. Backend - [http://localhost:52773/fhir/api/patient/all](http://localhost:52773/fhir/api/patient/all)
3. FHIR server - [http://localhost:52773/fhir/r4/Patient](http://localhost:52773/fhir/r4/Patient)

## Test FHIR REST API

Find the full list of APIs in [postman collection](other/IRIS-FHIR-Talk2Doc.postman_collection.json).

Basic Auth credentials, username - `SuperUser`, password - `SYS`. Sample curl for one endpoint below.

``` bash
curl --location 'http://localhost:52773/fhir/api/patient/all' \
--header 'Authorization: Basic U3VwZXJVc2VyOlNZUw=='
```


### Build and Run Frontend Vue app

```bash
cd ./src/vue
npm install
npm run build
npm run serve
```

## Test IRIS commands
Uncomment `print(rows)` in [irisfhirclient](src/python/irisfhirclient.py) to view results

1. Exec into container
    ```bash
    docker-compose exec iris iris session iris
    ```
2. IRIS commands
    ```bash
    do ##class(fhir.dc.FhirClient).GetResource("Patient")
    do ##class(fhir.dc.FhirClient).GetPatientResources("Observation","1")
    do ##class(fhir.dc.FhirClient).CreateDocumentForPatient(1, 3, "blablabla", "application/pdf")
    ```