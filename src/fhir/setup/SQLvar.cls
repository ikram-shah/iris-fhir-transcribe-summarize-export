Class fhir.setup.SQLvar
{

ClassMethod GetJSON(json As %String, name As %String) As %String(MAXLEN="") [ SqlName = GetJSON, SqlProc ]
{

    Quit:(json="") ""

    Set dyna = {}.%FromJSON(json)

    Set result = dyna.%Get(name)

    Quit $SELECT(result'="":$SELECT(($CLASSNAME(result)="%Library.DynamicObject")||($CLASSNAME(result)="%Library.DynamicArray"):result.%ToJSON(),1:{}.%Set(name,result,dyna.%GetTypeOf(name)).%ToJSON()),1:"")
}

ClassMethod GetProp(json As %String, prop As %String) As %String(MAXLEN="") [ SqlName = GetProp, SqlProc ]
{
    Quit:(json="") ""

    Set dyna = {}.%FromJSON(json)

    Quit dyna.%Get(prop)
}

ClassMethod GetAtJSON(json As %String, position As %Integer) As %String(MAXLEN="") [ SqlName = GetAtJSON, SqlProc ]
{
    Quit:(json="") ""

    Set dyna = [].%FromJSON(json)
    
    Set i = 0
    Set iterator = dyna.%GetIterator()
    
    While iterator.%GetNext(.key, .result) {
        Quit:(i=position) 
        Do $INCREMENT(i)
    }

    Quit $SELECT(result'="":$SELECT(($CLASSNAME(result)="%Library.DynamicObject")||($CLASSNAME(result)="%Library.DynamicArray"):result.%ToJSON(),1:{}.%Set(key,result,dyna.%GetTypeOf(key)).%ToJSON()),1:"")
}

/// Return JSON array resulting from FHIRPath query
ClassMethod GetFHIRPath(json As %String, path As %String, mdSetKey As %String = "HL7v40") As %String(MAXLEN="") [ SqlName = GetFHIRPath, SqlProc ]
{
	If (json = "") Quit ""
	
	#dim fpAPI As HS.FHIRPath.API = ##class(HS.FHIRPath.API).getInstance(mdSetKey)
	#dim node As HS.FHIRPath.Node = fpAPI.parse(path)

	#dim array As %DynamicArray = fpAPI.evaluateToJson({}.%FromJSON(json), node)
	//#dim array As %DynamicArray = $$%EvaluatePath^%DocDB.Document(json, path)
	If (array = "") Quit ""

	Quit array.%ToJSON()
}

/// Return just one result, either JSON object/array or a single value. 
/// resourceType argument is used to distinguish arrays from non-arrays.
ClassMethod GetFHIRPathOne(json As %String, path As %String, resourceType As %String, mdSetKey As %String = "HL7v40") As %String(MAXLEN="") [ SqlName = GetFHIRPathOne, SqlProc ]
{
	If (json = "") Quit ""
	
	#dim fpAPI As HS.FHIRPath.API = ##class(HS.FHIRPath.API).getInstance(mdSetKey)
	#dim node As HS.FHIRPath.Node = fpAPI.parse(path)

	#dim array As %DynamicArray = fpAPI.evaluateToJson({}.%FromJSON(json), node)
	//#dim array As %DynamicArray = $$%EvaluatePath^%DocDB.Document(json, path)
	If (array = "") Quit ""

	Do fpAPI.getPathAndType(resourceType, node, .contextPath, .fhirType)
	
	#dim result = array
	If (($GET(fhirType("ar")) = $$$NO) || ($EXTRACT($ZSTRIP(path, ">W"), *) = "]"))
	{
		Set result = array.%Get(0)
	}
	
	Quit $CASE($ISOBJECT(result), $$$YES:/*result.%ClassName(1) _ ":" _ */result.%ToJSON(), :result)
}

}

