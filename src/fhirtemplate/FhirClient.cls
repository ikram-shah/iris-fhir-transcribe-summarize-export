Class fhirtemplate.FhirClient Extends %SwizzleObject
{

// Create records in FHIRServer and initate Global Variable to hold current server ID 

ClassMethod Init() As %Integer
{
	If $DATA(^$GLOBAL("^ActiveFhirServer"))= 0 
	{
		Set ^ActiveFhirServer = 1
	}
	//if server id 1 is not already created then create server with ID 1
	Set obj = ##class(fhirtemplate.FhirServer).%OpenId(1)
	If $ISOBJECT(obj) = 0
	{
		Set obj = ##class(fhirtemplate.FhirServer).%New()
		Set obj.ServerName = "SmartHealthIT Open FHIR Server"
		Set obj.Endpoint = "http://localhost:52773/fhir/r4/"
	
		Set sts = obj.%Save()
		If sts '= 1
		{
			Quit "Error while creating server ID2"
		}
	}
	Quit $$$OK
}

// Resigter server by using FhirServer persistent Class

ClassMethod RegisterServer(ServerName As %String, Endpoint As %String, ApiKey As %String = "", EndpointOAuth As %String = "") As %Integer
{
	//Create global fhirServer reference variable if not created
	If $DATA(^$GLOBAL("^ActiveFhirServer"))= 0 
	{
		Set ^ActiveFhirServer = 1
	}
	//Add New FhirServer
	Set obj = ##class(fhirtemplate.FhirServer).%New()
	Set obj.ServerName = ServerName
	Set obj.Endpoint = Endpoint
	Set obj.ApiKey = ApiKey
	Set obj.EndpointOAuth = EndpointOAuth
	Set sts = obj.%Save()
	If sts = 1
	{
			Write "FHIR Server registered successfully"
			Quit $$$OK
			
	}
	Else
	{
			Quit "Error while registring FHIR Server"
	}
}

// Get Server List

ClassMethod ServerList() As %Integer
{

	//Print Servier List
	Set qry = "SELECT ID, ServerName, Endpoint,ApiKey FROM fhirtemplate.FhirServer"
	Set tStatement = ##class(%SQL.Statement).%New()
	Set qStatus = tStatement.%Prepare(.qry)
    If qStatus =1 {
             Set rsetD = tStatement.%Execute()
            
                    //DO rset.%Display()
    Write "------------------------------------------------------------------",!           
    Write "Registered FHIR Servers",!           
    Write "------------------------------------------------------------------",!  
    While rsetD.%Next() {
	                    If rsetD.%GetData(1)= ^ActiveFhirServer
    { 
        Set STS = "Active"
    }    
    Else
    {
	     Set STS = "Not Active"
	    }
             
              Write "ID", ?12,rsetD.%GetData(1),!
              Write "Name", ?12,rsetD.%GetData(2),!
              Write "EndPoint", ?12,rsetD.%GetData(3),!
              Write "ApiKey", ?12,rsetD.%GetData(4),!
              Write "EPOAuth2", ?12,rsetD.%GetData(5),!
              Write "ISActive", ?12,STS,!
             
              Write "------------------------------------------------------------------",!           
              
                                                
                        }
                 }
	Quit $$$OK
}

// Get Server List. Used in CSP application

ClassMethod GetServerList() As %String
{

	//Print Servier List
	Set qry = "SELECT ID, ServerName FROM fhirtemplate.FhirServer"
	Set tStatement = ##class(%SQL.Statement).%New()
	Set qStatus = tStatement.%Prepare(.qry)
    If qStatus =1 {
         Set rsetD = tStatement.%Execute()
            
             
   Set dtbl  = ""
       While rsetD.%Next() {
	If rsetD.%GetData(1)= ^ActiveFhirServer
    { 
        Set STS = "Active"
    }    
    Else
    {
	     Set STS = "Not Active"
	    }
                       
            Set dtbl = dtbl_"<tr><td>"_ rsetD.%GetData(1) _"</td><td>"_ rsetD.%GetData(2) _"</td><td>"_ STS _"</td></tr>"
                   
                                                
                        }
                        Return dtbl
                 }
                 Return ""
}

// Set Current FHIR Server

ClassMethod SetFhirServer(serverid As %Integer)
{
	Set obj = ##class(fhirtemplate.FhirServer).%OpenId(serverid)
	//If Server is already register then activate it
	If $ISOBJECT(obj)  
	{
		Set ^ActiveFhirServer = serverid
		Write "Server id Activated Successfully"
	}
	Else
	{
		Write "FHIR Server Not registered!"
	}
}

// Count Resource, Pass "ALL" in case of counting all the resources

ClassMethod CountResource(resource As %String) As %Integer
{
	//Get Active Server data based on Global Variable 
	Set obj = ##class(fhirtemplate.FhirServer).%OpenId(^ActiveFhirServer)
	//If Url and ApiKey is defined
	If $ISOBJECT(obj)  
	{  
	    
	  Try {
  		  //Importing python file 
          Set irisfhirclient = ##class(%SYS.Python).Import("irisfhirclient")
          
		} 
	  Catch err {
			Write "Error While importing irisfhirclient.py file" 	
			Return 0  	
				}  
	  //invoking Method from python file
	  Set count = irisfhirclient.CountResource(resource,obj.Endpoint,obj.ApiKey)
	  Return count
	}
	//Active Server data is not defined
  	Else
  	{ 
  		Quit "Not able to get server Info.."
  	}
  	Return count
}

// Count Patient Resources

ClassMethod CountResourcePatient(resource As %String, patientid As %String) As %Integer
{
	//Get Active Server data based on Global Variable 
	Set obj = ##class(fhirtemplate.FhirServer).%OpenId(^ActiveFhirServer)
	//If Url and ApiKey is defined
	If $ISOBJECT(obj)  
	{  
	    
	  Try {
  		  //Importing python file 
          Set irisfhirclient = ##class(%SYS.Python).Import("irisfhirclient")
          
		} 
	  Catch err {
			Write "Error While importing irisfhirclient.py file" 	
			Return 0  	
				}  
	  //invoking Method from python file
	  Set count = irisfhirclient.CountResourcePatient(resource,patientid,obj.Endpoint,obj.ApiKey)
	  Return count
	}
	//Active Server data is not defined
  	Else
  	{ 
  		Quit "Not able to get server Info.."
  	}
  	Return count
}

// Method invoked from CSP Application to get Resource HTML

ClassMethod GetResourceHTML(resource As %String) As %Status
{
	//Get Active Server data based on Global Variable 
	Set obj = ##class(fhirtemplate.FhirServer).%OpenId(^ActiveFhirServer)
	//If Url and ApiKey is defined
	If $ISOBJECT(obj)  
	{  
	  //Call Embedded Python Function to get Number of Resources
	  Set irisfhirclient = ##class(%SYS.Python).Import("irisfhirclient")
	  Set data = irisfhirclient.GetResourceHTML(resource,obj.Endpoint,obj.ApiKey) 
	  

	}
	//Active Server data is not defined
  	Else
  	{ 
  		Quit "Not able to get server Info.."
  	}
  	Return data
}

// Get Resource List 

ClassMethod GetResource(resource As %String, searchParm = "", searchVal = "") As %Status
{
	//Get Active Server data based on Global Variable 
	Set obj = ##class(fhirtemplate.FhirServer).%OpenId(^ActiveFhirServer)
	//If Url and ApiKey is defined
	If $ISOBJECT(obj)  
	{  
	  //Call Embedded Python Function to get Number of Resources
	  Set irisfhirclient = ##class(%SYS.Python).Import("irisfhirclient")
	  Set data = irisfhirclient.GetResource(resource,searchParm,searchVal,obj.Endpoint,obj.ApiKey) 
	}
	//Active Server data is not defined
  	Else
  	{ 
  		Quit "Not able to get server Info.."
  	}
	Return data
}

ClassMethod ListResources(opt As %Integer = 0) As %Status
{
	//Get Active Server data based on Global Variable 
	Set obj = ##class(fhirtemplate.FhirServer).%OpenId(^ActiveFhirServer)
	//If Url and ApiKey is defined
	If $ISOBJECT(obj)  
	{  
	  //Call Embedded Python Function to get Number of Resources
	  Set irisfhirclient = ##class(%SYS.Python).Import("irisfhirclient")
	  Do irisfhirclient.ListResources(obj.Endpoint,obj.ApiKey,opt) 
	}
	//Active Server data is not defined
  	Else
  	{ 
  		Quit "Not able to get server Info.."
  	}
  	Quit $$$OK
}

//  Get Patint Resources List 

ClassMethod GetPatientResources(resource As %String, patientId As %Integer) As %Status
{
	//Get Active Server data based on Global Variable 
	Set obj = ##class(fhirtemplate.FhirServer).%OpenId(^ActiveFhirServer)
	//If Url and ApiKey is defined
	If $ISOBJECT(obj)  
	{  
	  //Call Embedded Python Function to get Number of Resources
	  Set irisfhirclient = ##class(%SYS.Python).Import("irisfhirclient")
	  Set data = irisfhirclient.GetPatientResources(resource,patientId,obj.Endpoint,obj.ApiKey) 
	}
	//Active Server data is not defined
  	Else
  	{ 
  		Quit "Not able to get server Info.."
  	}
	Return data
}

// Get patient data to be used in csp application

ClassMethod GetPatientResourcesHTML(resource As %String, patientId As %Integer) As %Status
{
	//Get Active Server data based on Global Variable 
	Set obj = ##class(fhirtemplate.FhirServer).%OpenId(^ActiveFhirServer)
	//If Url and ApiKey is defined
	If $ISOBJECT(obj)  
	{  
	  //Call Embedded Python Function to get Number of Resources
	  Set irisfhirclient = ##class(%SYS.Python).Import("irisfhirclient")
	  Set data = irisfhirclient.GetPatientResourcesHTML(resource,patientId,obj.Endpoint,obj.ApiKey) 
	}
	//Active Server data is not defined
  	Else
  	{ 
  		Quit "Not able to get server Info.."
  	}
  	Return data
}

// Function to get tables header row based on resource

ClassMethod GetHeaderRow(id As %Integer) As %String
{
    If id = 1 
	{
		//Patients Header
		Set hrow = "<th>ID</th><th>Family Name</th><th>Given Name</th><th>DOB</th><th>Gender</th>"
	}
	ElseIf id = 2
	{
		//Server Header
		Set hrow = "<th>ID</th><th>Server Name</th><th>Status</th>"
	}
	ElseIf id = 3
	{
		//Observation
	
		Set hrow = "<th>ID</th><th>Category</th><th>Codes</th><th>Value</th><th>UOM</th><th>Date</th>"
	}

    Return hrow
}

// Function to create Patient resource

ClassMethod CreatePatient(givenName As %String, familyName As %String, birthDate As %String, gender As %String)
{
	//Get Active Server data based on Global Variable 
	Set obj = ##class(fhirtemplate.FhirServer).%OpenId(^ActiveFhirServer)
	//If Url and ApiKey is defined
	If $ISOBJECT(obj)  
	{  
	//Call Embedded Python Function to get Number of Resources
	Set irisfhirclient = ##class(%SYS.Python).Import("irisfhirclient")
	Set data = irisfhirclient.CreatePatient(givenName,familyName,birthDate,gender,obj.Endpoint,obj.ApiKey) 
	}
	//Active Server data is not defined
	Else
	{ 
	Quit "Not able to get server Info.."
	}
}

// Function to create Patient observations

ClassMethod CreateObservation(patientId As %String, loincCode As %String, ObrCategory As %String, ObrValue As %Integer, ObrUOM As %String, effectiveDate As %String)
{
	
	//Get Active Server data based on Global Variable 
	Set obj = ##class(fhirtemplate.FhirServer).%OpenId(^ActiveFhirServer)
	//If Url and ApiKey is defined
	If $ISOBJECT(obj)  
	{  
	//Call Embedded Python Function to get Number of Resources
	Set irisfhirclient = ##class(%SYS.Python).Import("irisfhirclient")
	Set data = irisfhirclient.CreateObservation(patientId,loincCode,ObrCategory,ObrValue,ObrUOM,effectiveDate,obj.Endpoint,obj.ApiKey) 
	}
	//Active Server data is not defined
	Else
	{ 
	Quit "Not able to get server Info.."
	}
}

}
