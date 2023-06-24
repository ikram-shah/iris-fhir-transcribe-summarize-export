Class fhirtemplate.FhirServer Extends %Persistent
{

Property ServerName As %String;

Property Endpoint As %String(MAXLEN = 200);

Property ApiKey As %String;

Property EndpointOAuth As %String(MAXLEN = 200);

Storage Default
{
<Data name="FhirServerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ServerName</Value>
</Value>
<Value name="3">
<Value>Endpoint</Value>
</Value>
<Value name="4">
<Value>ApiKey</Value>
</Value>
<Value name="5">
<Value>EndpointOAuth</Value>
</Value>
</Data>
<DataLocation>^fhirtemplate.FhirServerD</DataLocation>
<DefaultData>FhirServerDefaultData</DefaultData>
<IdLocation>^fhirtemplate.FhirServerD</IdLocation>
<IndexLocation>^fhirtemplate.FhirServerI</IndexLocation>
<StreamLocation>^fhirtemplate.FhirServerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
