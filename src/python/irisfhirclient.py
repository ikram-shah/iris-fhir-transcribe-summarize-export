import json
from fhirpy import SyncFHIRClient
from tabulate import tabulate
from fhirpy.base.searchset import Raw
import requests

contentType = "application/fhir+json"

#Get Table header based on resource
def GetTableHeader(resource):
    if resource == "Patient":
        header = ["ID","Family Name","Given Name","DOB","Gender"]
    elif resource == "Observation":
        header = ["ID","Category","Code","Value","UOM","Date","Patient"]
    else:
        header = "NA"
    return header
    
#Function to get data in rows format
def GetTableData(resource,data,opt):
    rows = []
    if opt == 1: #Get Rows Data
        if resource == "Patient":
            for rowval in data:
                row = [rowval.get('id'),rowval.get_by_path('name.0.family'),rowval.get_by_path('name.0.given.0'),rowval.get_by_path('birthDate'),rowval.get_by_path('gender')]
                rows.append(row)
        elif resource == "Observation":
            for rowval in data:
                row = [rowval.get('id'),
                rowval.get_by_path('category.0.coding.0.code'),
                rowval.get_by_path('code.coding.0.code'),
                rowval.get_by_path('valueQuantity.value'),
                rowval.get_by_path('valueQuantity.code'),
                rowval.get('effectiveDateTime'),
                rowval.get_by_path('subject.reference')
                ,]
                rows.append(row)    
    return rows


#2-Print patient resource from terminal
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
          
    rows = GetTableData(resource,data,1)
    #print(rows)
    return str(rows)
    
#3-Print resource agaisnt Patient
def GetPatientResources(resource,patientId,url,api_key):
     #Get Connection
    cclient = SyncFHIRClient(url = url, extra_headers={"Content-Type":contentType,"x-api-key":api_key})
    try:
        data = cclient.resources(resource).search(patient=patientId).fetch()
    except:
        print("Not able to get Resource Information") 
        return    
    header = GetTableHeader(resource)
    if header == "NA":
        print(data)
    rows = GetTableData(resource,data,1)
    #print(rows)
    return rows
  
        
