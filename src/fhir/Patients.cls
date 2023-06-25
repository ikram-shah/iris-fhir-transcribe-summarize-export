Class fhir.Patients Extends %CSP.REST
{

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Route Url="/patient/all" Method="GET" Call="getAllPatients" Cors="true"/>
</Routes>
}

ClassMethod getAllPatients() As %Status
{
    Set %response.ContentType = "application/json"

    Set tSC = $SYSTEM.Status.OK()

    Set patientsString = ##class(fhir.dc.FhirClient).GetResource("Patient")

    Write patientsString

    Quit $$$OK
}

}
