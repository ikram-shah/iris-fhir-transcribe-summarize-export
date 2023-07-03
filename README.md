# IRIS FHIR Transcribe-Summarize-Export

![Quality Gate Status](https://github.com/ikram-shah/iris-fhir-transcribe-summarize-export/actions/workflows/objectscript-quality.yml/badge.svg)

 🚀 *Built by [Ikram Shah](https://community.intersystems.com/user/ikram-shah) and [Sowmiya Nagarajan](https://community.intersystems.com/user/sowmiya-nagarajan).*

## Demo

https://github.com/ikram-shah/iris-fhir-transcribe-summarize-export/assets/20276568/9edfedab-2d3d-442c-8853-21123bc49224

## Overview

This is a full-stack application that allows practitioners and other clinicians to record voice notes linked to a subject and also export them to Google Docs/Sheets. 

1. The UI enables voice recording and the audio is transcribed to text using **Open AI Whisper API**.
2. Then the notes are summarized using **Open AI text-davinci-003** model and stored as **Document References** in FHIR server. 
3. Finally, there is an option to export the stored documents to **Google Docs** in an account of user's choice through OAuth2. Other data like Observations can be exported to **Google Sheets**.

> **Note** - This implements a [Community idea](https://ideas.intersystems.com/ideas/DPI-I-197)💡. Docs and Sheets export is directly handled via REST api in IRIS now. It's not an interoperability adapter yet and it's WIP.

The application also acts as a dashboard to view patient and other information like observations and encounters.

The frontend UI is built as a **Vue.js** app. The backend is powered by **IRIS REST** api and there is an underlying FHIR server running to store all data. The application uses **embedded-python** to connect to FHIR api via `fhirpy` module.

## Build and run
1. Refer [here](https://www.howtogeek.com/885918/how-to-get-an-openai-api-key/) to create an OpenAI API key. This is used in the transcription and summarizing the voice notes features. Set the key in [.env](.env) for frontend.
2. Follow steps in following section to configure OAuth Client ID for Google docs/sheets export. Set it in [.env](.env).
3. Run below script to start frontend and backend apps. UI hot reloads, so no need to rebuild for every change. But backend needs a rebuild every time.
    ```bash
    ./scripts/rebuild.sh
    ```

## Useful Links

1. UI - [http://localhost:8080](http://localhost:8080)
2. Backend - [http://localhost:52773/fhir/api/patient/all](http://localhost:52773/fhir/api/patient/all)
3. FHIR server - [http://localhost:52773/fhir/r4/Patient](http://localhost:52773/fhir/r4/Patient)

## Configure Google OAuth Client ID
❗The below steps take only a few minutes to get a new Client ID for testing. But, feel free to raise an issue to add specific mail IDs to our existing client ID to test quickly.❗

1. Follow steps [here](https://support.google.com/cloud/answer/6158849?hl=en#zippy=%2Cweb-applications) to create a OAuth consent screen and client ID for a test project.
2. Add scope required for docs and sheets export - `https://www.googleapis.com/auth/documents, https://www.googleapis.com/auth/spreadsheets`
3. Configure authorized javascript origin and authorized redirect URI as `http://localhost:8080` or whichever port you run the frontend vue app on.
4. Add some test user email IDs to allow testing. Only these users can authorize via the OAuth flow. If you need to open it up for more users, then a mandatory review process is required. More details [here](https://support.google.com/cloud/answer/10311615?hl=en).
5. Set the obtained client ID in [.env](.env)

## Test FHIR REST API

Find the full list of APIs in **[Postman Collection](other/IRIS-FHIR-Transcribe-Summarize-Export.postman_collection.json)**.

Basic Auth credentials, username - `SuperUser`, password - `SYS`. 

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
    ```
