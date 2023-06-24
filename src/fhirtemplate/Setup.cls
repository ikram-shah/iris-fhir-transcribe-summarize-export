Class fhirtemplate.Setup
{

ClassMethod SetupFHIRServer(ns) As %Status
{
    Set ns=$GET(ns,$NAMESPACE)
    Set ns="FHIRSERVER"
    ZNspace "HSLIB"
    Set namespace=ns
    Set appKey = "/fhir/r4"
    Set strategyClass = "HS.FHIRServer.Storage.Json.InteractionsStrategy"
    Set metadataPackages = $LISTBUILD("hl7.fhir.r4.core@4.0.1")
    Set metadataConfigKey = "HL7v40"
    ;set importdir="/opt/irisapp/src"

    //Install a Foundation namespace and change to it
    Do ##class(HS.HC.Util.Installer).InstallFoundation(namespace)
    ZNspace namespace

    // Install elements that are required for a FHIR-enabled namespace
    Do ##class(HS.FHIRServer.Installer).InstallNamespace()

    // Install an instance of a FHIR Service into the current namespace
    If '##class(HS.FHIRServer.ServiceAdmin).EndpointExists(appKey) {
       Do ##class(HS.FHIRServer.Installer).InstallInstance(appKey, strategyClass, metadataPackages)
    }

    Set strategy = ##class(HS.FHIRServer.API.InteractionsStrategy).GetStrategyForEndpoint(appKey)
    Set config = strategy.GetServiceConfigData()
    Set config.DebugMode = 4
    Do strategy.SaveServiceConfigData(config)

    Set dir=$SYSTEM.Util.ManagerDirectory()_"test-data-fhir"
    Write !," ====== Load test data in "_ns_" from "_dir
    Set st=##class(HS.FHIRServer.Tools.DataLoader).SubmitResourceFiles(dir, "FHIRServer", appKey)
    If 'st Write $SYSTEM.Status.GetErrorText(st)
    Quit st
}

ClassMethod LoadPatientData(path, namespace, appKey) As %Status
{
    Quit ##class(HS.FHIRServer.Tools.DataLoader).SubmitResourceFiles(path, namespace, appKey)
}

ClassMethod AddApp(ns={$NAMESPACE}) As %Status
{
    Set namespace=ns
    ZNspace "%SYS"
    Set webName = "/ui/dist" 
    Set webProperties("NameSpace") = namespace 
    Set webProperties("Enabled") = 1 
    Set webProperties("Path") = "/irisdev/app/ui/dist"
    Set webProperties("AutheEnabled") = 64 
    Set webProperties("ServeFiles")=2
    Set webProperties("Recurse")=1
    Quit ##class(Security.Applications).Create(webName, .webProperties)
}

}
