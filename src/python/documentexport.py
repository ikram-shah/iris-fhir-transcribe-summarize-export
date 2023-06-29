import requests
import json
from irisfhirclient import *
from template import *
import base64

import os
import openai

openai.api_key = os.getenv("OPENAI_API_KEY")


def Summarize(text):
    response = openai.Completion.create(
        model="text-davinci-003",
        prompt="summarize this =" + text,
        temperature=1,
        top_p=1,
        frequency_penalty=0,
        presence_penalty=1
    )
    resp = {
        "summary": response["choices"][0]["text"]
    }
    return json.dumps(resp)


def CreateGoogleDoc(patientId, docId, token):
    url = 'https://docs.googleapis.com/v1/documents'

    documents = json.loads(GetPatientResources(
        "DocumentReference", patientId, "http://localhost:52773/fhir/r4/", ""))

    payload = 'not found'
    docMatch = None

    for doc in documents:
        if doc['id'] == str(docId):
            docMatch = doc

    base64_bytes = docMatch['base64payload'].encode('utf-8')
    message_bytes = base64.b64decode(base64_bytes)

    # Set the desired document content
    document_content = create_doc(
        "Ikram Shah V", docMatch["updatedDate"], message_bytes.decode('utf-8'))

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

    # Set the desired document content
    document_content = insert_text(message_bytes.decode('utf-8'))

    # Convert the document content to JSON
    document_json = json.dumps(document_content)

    # Send the API request to create the document
    response = requests.post(
        "https://docs.googleapis.com/v1/documents/"+document_id+":batchUpdate",
        headers={'Authorization': f'Bearer {token}',
                 'Content-Type': 'application/json'},
        data=document_json
    )

    # Check if the request was successful
    if response.status_code == 200:
        print(f"Google Doc updated successfully! Document ID: {document_id}")
    else:
        print("Failed to update Google Doc.")
        print(response.json())
