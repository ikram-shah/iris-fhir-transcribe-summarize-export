import requests
import json
from irisfhirclient import *


def CreateGoogleDoc(patientId, docId, token):
    url = 'https://docs.googleapis.com/v1/documents'

    documents = json.loads(GetPatientResources(
        "DocumentReference", patientId, "http://localhost:52773/fhir/r4/", ""))

    payload = 'not found'

    for doc in documents:
        if doc['id'] == str(docId):
            payload = doc['base64payload']

    print(payload)

    # Set the desired document content
    document_content = {
        'title': 'FHIR Doc',
        'body': {
            'content': [
                {
                    'paragraph': {
                        'elements': [
                            {
                                'textRun': {
                                    'content': payload
                                }
                            }
                        ]
                    }
                }
            ]
        }
    }

    # Convert the document content to JSON
    document_json = json.dumps(document_content)

    # Send the API request to create the document
    response = requests.post(
        url,
        headers={'Authorization': f'Bearer {token}',
                 'Content-Type': 'application/json'},
        data=document_json
    )

    # Check if the request was successful
    if response.status_code == 200:
        document_id = response.json()['documentId']
        print(f"Google Doc created successfully! Document ID: {document_id}")
    else:
        print("Failed to create Google Doc.")
        print(response.json())
