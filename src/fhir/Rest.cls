Class fhir.Rest Extends %CSP.REST
{

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Route Url="/patient/all" Method="GET" Call="getAllPatients" Cors="true"/>
<Route Url="/documentreference" Method="POST" Call="createDocument" Cors="true"/>
<Route Url="/patient/:patientId/:resource" Method="GET" Call="getPatientResource" Cors="true"/>
<Route Url="/patient/:patientId" Method="GET" Call="getPatient" Cors="true"/>
<Route Url="/documentReference/:documentReferenceId" Method="GET" Call="getDocumentReference" Cors="true"/>
<Route Url="/exportDocument" Method="POST" Call="exportDocument" Cors="true"/>
<Route Url="/exportSheet" Method="POST" Call="exportSheet" Cors="true"/>
<Route Url="/summarize" Method="POST" Call="summarize" Cors="true"/>
<Route Url="/queryDocs" Method="POST" Call="query" Cors="true"/>
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

ClassMethod getPatient(patientId As %String) As %Status
{
    Set %response.ContentType = "application/json"

    Set tSC = $SYSTEM.Status.OK()

    Set resp = ##class(fhir.dc.FhirClient).GetResource("Patient", patientId)

    Write resp

    Quit $$$OK
}

ClassMethod getDocumentReference(documentReferenceId As %String) As %Status
{
    Set %response.ContentType = "application/json"

    Set tSC = $SYSTEM.Status.OK()

    Set resp = ##class(fhir.dc.FhirClient).GetResource("DocumentReference", documentReferenceId)

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
	
	If '..ValidateJSONCreateDocument(obj,.error) {
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

ClassMethod summarize() As %Status
{
   Set %response.ContentType = "application/json"

    If '..GetJSONFromRequest(.obj) {
		Set %response.Status = ..#HTTP400BADREQUEST
		Set error = {"errormessage": "JSON not found"}
		Write error.%ToJSON()
		Quit $$$OK
	}
	
	If '..ValidateJSONSummarize(obj,.error) {
		Set %response.Status = ..#HTTP400BADREQUEST
		Write error.%ToJSON()
		Quit $$$OK
	}
    Set tSC = $SYSTEM.Status.OK()

    Set resp = ##class(fhir.dc.FhirClient).Summarize(obj.text)

    Write resp

    Quit $$$OK
}

ClassMethod exportDocument() As %Status
{
    Set %response.ContentType = "application/json"

    If '..GetJSONFromRequest(.obj) {
		Set %response.Status = ..#HTTP400BADREQUEST
		Set error = {"errormessage": "JSON not found"}
		Write error.%ToJSON()
		Quit $$$OK
	}
	
	If '..ValidateJSONExportDocument(obj,.error) {
		Set %response.Status = ..#HTTP400BADREQUEST
		Write error.%ToJSON()
		Quit $$$OK
	}
    Set tSC = $SYSTEM.Status.OK()

    Set resp = ##class(fhir.dc.FhirClient).ExportDocument(obj.title, obj.body, obj.token)

    Write resp

    Quit $$$OK
}

ClassMethod exportSheet() As %Status
{
    Set %response.ContentType = "application/json"

    If '..GetJSONFromRequest(.obj) {
		Set %response.Status = ..#HTTP400BADREQUEST
		Set error = {"errormessage": "JSON not found"}
		Write error.%ToJSON()
		Quit $$$OK
	}
	
	If '..ValidateJSONExportSheet(obj,.error) {
		Set %response.Status = ..#HTTP400BADREQUEST
		Write error.%ToJSON()
		Quit $$$OK
	}
    Set tSC = $SYSTEM.Status.OK()

    Set resp = ##class(fhir.dc.FhirClient).ExportSheet(obj.title, obj.rows, obj.token)

    Write resp

    Quit $$$OK
}

ClassMethod query() As %Status
{
   Set %response.ContentType = "application/json"

    If '..GetJSONFromRequest(.obj) {
		Set %response.Status = ..#HTTP400BADREQUEST
		Set error = {"errormessage": "JSON not found"}
		Write error.%ToJSON()
		Quit $$$OK
	}
	
	If '..ValidateJSONQuery(obj,.error) {
		Set %response.Status = ..#HTTP400BADREQUEST
		Write error.%ToJSON()
		Quit $$$OK
	}
    Set tSC = $SYSTEM.Status.OK()

    Set resp = ##class(fhir.dc.FhirClient).QueryDocs(obj.query)

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

ClassMethod ValidateJSONExportDocument(obj As %DynamicObject, Output error As %DynamicObject) As %Boolean
{
	Set error = {}

	If obj.%Get("title") = "" {
		Set error.errormessage = "title is missing"
		Quit 0
	}
	
	If obj.%Get("body") = "" {
		Set error.errormessage = "body is missing"
		Quit 0
	}

    If obj.%Get("token") = "" {
		Set error.errormessage = "oAuth token is missing"
		Quit 0
	}
	
	Quit 1
}

ClassMethod ValidateJSONExportSheet(obj As %DynamicObject, Output error As %DynamicObject) As %Boolean
{
	Set error = {}

	If obj.%Get("title") = "" {
		Set error.errormessage = "title is missing"
		Quit 0
	}
	
	If obj.%Get("rows") = "" {
		Set error.errormessage = "rows is missing"
		Quit 0
	}

    If obj.%Get("token") = "" {
		Set error.errormessage = "oAuth token is missing"
		Quit 0
	}
	
	Quit 1
}

ClassMethod ValidateJSONQuery(obj As %DynamicObject, Output error As %DynamicObject) As %Boolean
{
	Set error = {}
	
	If obj.%Get("query") = "" {
		Set error.errormessage = "query is missing"
		Quit 0
	}
	
	Quit 1
}

ClassMethod ValidateJSONSummarize(obj As %DynamicObject, Output error As %DynamicObject) As %Boolean
{
	Set error = {}
	
	If obj.%Get("text") = "" {
		Set error.errormessage = "text is missing"
		Quit 0
	}
	
	Quit 1
}

ClassMethod ValidateJSONCreateDocument(obj As %DynamicObject, Output error As %DynamicObject) As %Boolean
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
