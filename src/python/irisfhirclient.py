import json
from fhirpy import SyncFHIRClient
from tabulate import tabulate
from fhirpy.base.searchset import Raw

contentType = "application/fhir+json"
    
def FormatResource(resource,data,opt):
    rows = []
    if opt == 1: #Get Rows Data
        if resource == "Patient":
            for rowval in data:
                row = {
                    "id": rowval.get('id'),
                    "lastName": rowval.get_by_path('name.0.family'),
                    "firstName": rowval.get_by_path('name.0.given.0'),
                    "birthDate": rowval.get_by_path('birthDate'),
                    "gender": rowval.get_by_path('gender')
                }
                rows.append(row)
        elif resource == "Observation":
            for rowval in data:
                row = {
                    "id": rowval.get('id'),
                    "category": rowval.get_by_path('category.0.coding.0.code'),
                    "code": rowval.get_by_path('code.coding.0.code'),
                    "value": rowval.get_by_path('valueQuantity.value'),
                    "uom": rowval.get_by_path('valueQuantity.code'),
                    "date": rowval.get('effectiveDateTime'),
                    "patientId": rowval.get_by_path('subject.reference')
                }
                rows.append(row)   
        elif resource == 'DocumentReference':        
            for rowval in data:
                row = {
                    "id": rowval.get('id'),
                    "patientId": rowval.get_by_path('subject.reference'),
                    "practitionerId": rowval.get_by_path('author.0.reference'),
                    "base64payload": rowval.get_by_path('content.0.attachment.data'),
                    "mimeType": rowval.get_by_path('content.0.attachment.contentType'),
                    "updatedDate": rowval.get_by_path('meta.lastUpdated'),
                }
                rows.append(row)      
    return rows


def GetResource(resource,searchFor,searchVal,url,api_key):
    #Get Connection
    client = SyncFHIRClient(url = url, extra_headers={"Content-Type":contentType,"x-api-key":api_key})
    data = ""
    try:
        if len(searchVal) > 0 and resource == 'Patient':
            data = client.resources(resource).search(Raw(**{searchFor:searchVal})).fetch()  
                                                
        else:
            data = client.resources(resource).fetch()           
            
    except Exception as e:
        print("Error :" + str(e))    
          
    rows = FormatResource(resource,data,1)
    #print(rows)
    return json.dumps(rows)
    
def GetPatientResources(resource,patientId,url,api_key):
    #Get Connection
    cclient = SyncFHIRClient(url = url, extra_headers={"Content-Type":contentType,"x-api-key":api_key})
    try:
        data = cclient.resources(resource).search(patient=patientId).fetch()
    except:
        print("Unable to get Resource Type") 
        return    
    rows = FormatResource(resource,data,1)
    #print(rows)
    return json.dumps(rows)
  
def CreateDocumentForPatient(patientId, practitionerId, base64payload, mimeType, url, api_key):
    headers = {"Content-Type":contentType,"x-api-key":api_key}
    client = SyncFHIRClient(url = url, extra_headers=headers)
    
    patient = client.resources('Patient').search(_id=patientId).first()
    practitioner = client.resources('Practitioner').search(_id=practitionerId).first()
    docref = client.resource("DocumentReference")

    docref["status"] = "current"
    docref["content"] = [{
                "attachment": {
                    "contentType": mimeType,
                    "data": base64payload
                }
            }]

    docref['author'] = [practitioner.to_reference()]
    docref['subject'] = patient.to_reference()

    try:
        docref.save()
    except Exception as e:
        return "Error while creating DocumentReference:" +str(e)      
    
    return "Document Reference Created Successfully"