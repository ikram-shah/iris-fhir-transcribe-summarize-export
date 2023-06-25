Class fhir.dc.FhirClient Extends %SwizzleObject
{

// Initiate FHIR 
ClassMethod Init() As %Integer
{
	//if server id 1 is not already created then create server with ID 1
	Set obj = ##class(fhir.dc.FhirServer).%OpenId(1)
	If $ISOBJECT(obj) = 0
	{
		Set obj = ##class(fhir.dc.FhirServer).%New()
		Set obj.ServerName = "Local FHIR server"
		Set obj.Endpoint = "http://localhost:52773/fhir/r4/"
	
		Set sts = obj.%Save()
		If sts '= 1
		{
			Quit "Error while connecting to server"
		}
	}
	Quit $$$OK
}


//  Get Resource
ClassMethod GetResource(resource As %String, searchParm = "", searchVal = "") As %Status
{
	Set obj = ##class(fhir.dc.FhirServer).%OpenId(1)

	If $ISOBJECT(obj)  
	{  
	  //Call Embedded Python Function to get requested resource
	  Set irisfhirclient = ##class(%SYS.Python).Import("irisfhirclient")
	  Set data = irisfhirclient.GetResource(resource,searchParm,searchVal,obj.Endpoint,obj.ApiKey) 
	}
  	Else
  	{ 
  		Quit "Unable to fetch server info"
  	}

	Return data
}


//  Get Patient Resources List 
ClassMethod GetPatientResources(resource As %String, patientId As %Integer) As %Status
{
	Set obj = ##class(fhir.dc.FhirServer).%OpenId(1)

	If $ISOBJECT(obj)  
	{  
	  //Call Embedded Python Function to get patient resources
	  Set irisfhirclient = ##class(%SYS.Python).Import("irisfhirclient")
	  Set data = irisfhirclient.GetPatientResources(resource,patientId,obj.Endpoint,obj.ApiKey) 
	}
  	Else
  	{ 
  		Quit "Unable to fetch server info"
  	}

	Return data
}

}
