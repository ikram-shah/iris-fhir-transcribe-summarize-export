Class fhir.Patients Extends %CSP.REST
{

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Route Url="/patient/all" Method="GET" Call="getAllPatients" Cors="true"/>
<Route Url="/documentreference" Method="POST" Call="createDocument" Cors="true"/>
<Route Url="/patient/:patientId/:resource" Method="GET" Call="getPatientResource" Cors="true"/>
</Routes>
}

ClassMethod getAllPatients() As %Status
{
    Set %response.ContentType = "application/json"

    Set tSC = $SYSTEM.Status.OK()

    Set resp = ##class(fhir.dc.FhirClient).GetResource("Patient")

    Write resp

    Quit $$$OK
}

ClassMethod createDocument() As %Status
{
    Set %response.ContentType = "application/json"

    If '..GetJSONFromRequest(.obj) {
		Set %response.Status = ..#HTTP400BADREQUEST
		Set error = {"errormessage": "JSON not found"}
		Write error.%ToJSON()
		Quit $$$OK
	}
	
	If '..ValidateJSON(obj,.error) {
		Set %response.Status = ..#HTTP400BADREQUEST
		Write error.%ToJSON()
		Quit $$$OK
	}

    Set tSC = $SYSTEM.Status.OK()

    Set resp = ##class(fhir.dc.FhirClient).CreateDocumentForPatient(obj.patientId, obj.practitionerId, obj.base64payload, obj.mimeType)

    Write resp

    Quit $$$OK
}

ClassMethod getPatientResource(patientId As %Integer, resource As %String) As %Status
{
    Set %response.ContentType = "application/json"

    Set tSC = $SYSTEM.Status.OK()

    Set resp = ##class(fhir.dc.FhirClient).GetPatientResources(resource, patientId)

    Write resp

    Quit $$$OK
}

// Helper methods
ClassMethod GetJSONFromRequest(Output obj As %DynamicObject) As %Boolean
{
	Set ok = 1
	Try {
		Set obj = ##class(%DynamicObject).%FromJSON(%request.Content)
	} Catch ex {
		Set ok = 0
	}
	Quit ok
}

ClassMethod ValidateJSON(obj As %DynamicObject, Output error As %DynamicObject) As %Boolean
{
	Set error = {}
	
	If obj.%Get("patientId") = "" {
		Set error.errormessage = "patientId is missing"
		Quit 0
	}	
	
	If obj.%Get("practitionerId") = "" {
		Set error.errormessage = "practitionerId is missing"
		Quit 0
	}

    If obj.%Get("base64payload") = "" {
		Set error.errormessage = "base64payload is missing"
		Quit 0
	}

    If obj.%Get("mimeType") = "" {
		Set error.errormessage = "mimeType is missing"
		Quit 0
	}
	
	Quit 1
}

}
