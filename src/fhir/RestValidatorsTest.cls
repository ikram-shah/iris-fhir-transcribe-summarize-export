Class fhir.RestValidatorsTest Extends %UnitTest.TestCase
{
    Method TestDocumentJSONValidatorFailWhenEmptyBody(){
          Do $$$AssertEquals(##class(fhir.Rest).ValidateJSONCreateDocument({}, {}), 0)  
    }

    Method TestDocumentJSONValidatorSuccess(){
          Set validBody = {
             "patientId": 1,
             "practitionerId": 3,
             "base64payload": "<some-payload>",
             "mimeType": "application/pdf"
          }
          Do $$$AssertEquals(##class(fhir.Rest).ValidateJSONCreateDocument(validBody, {}), 1)  
    }
    
    Method TestDocumentJSONValidatorFailWhenMissingKeyInBody(){
          Set invalidBody = {
             "patientId": 1,
             "practitionerId": 3,
             "mimeType": "application/pdf"
          }
          Do $$$AssertEquals(##class(fhir.Rest).ValidateJSONCreateDocument(invalidBody, {}), 0)  
    }

    Method TestExportDocJSONValidatorSuccess(){
          Set validBody = {
                "title": "title",
                "body": "body",
                "token": "token"
            }
          Do $$$AssertEquals(##class(fhir.Rest).ValidateJSONExportDocument(validBody, {}), 1)  
    }
    
    Method TestExportDocJSONValidatorFailWhenMissingKeyInBody(){
          Set invalidBody = {
                "title": "title",
                "body": "body"
            }
          Do $$$AssertEquals(##class(fhir.Rest).ValidateJSONExportDocument(invalidBody, {}), 0)  
    }
}