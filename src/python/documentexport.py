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
        prompt="summarize this and give title in json format - " + text,
        temperature=1,
        max_tokens=300,
        top_p=1,
        frequency_penalty=0,
        presence_penalty=1
    )
    return response["choices"][0]["text"].replace('\n', '')


def CreateGoogleDoc(title, body, token):
    url = 'https://docs.googleapis.com/v1/documents'

    base64_bytes = body.encode('utf-8')
    message_bytes = base64.b64decode(base64_bytes)

    # Set the desired document content
    document_content = get_create_doc_template(title)

    # Convert the document content to JSON
    document_json = json.dumps(document_content)

    # Send the API request to create the document
    response = requests.post(
        url,
        headers={'Authorization': f'Bearer {token}',
                 'Content-Type': 'application/json'},
        data=document_json
    )

    resp = dict()

    # Check if the request was successful
    if response.status_code == 200:
        document_id = response.json()['documentId']
        resp["googleDocId"] = document_id
        resp["status"] = "Created doc with title successfully."
    else:
        resp["status"] = "Failed to create Google Doc."
        return resp

    # Set the desired document content
    document_content = get_insert_text_template(message_bytes.decode('utf-8'))

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
        resp["status"] = "Updated doc with text successfully."
    else:
        resp["status"] = "Failed to update Google Doc."

    return json.dumps(resp)
