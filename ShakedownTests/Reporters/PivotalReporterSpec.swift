import Foundation
import Nimble
@testable import Shakedown
import Mockingjay

class PivotalReporterSpec: ReporterSpec {
    
    override var reporter: Reporter {
        return PivotalReporter(authenticationToken: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa", projectID: "1234567")
    }
    
    override var expectedMessage: String {
        return "91252164"
    }
    
    override func stubAndVerifyRequest(request: NSURLRequest) -> Response {
        expect(request.URL!.absoluteString) == "https://www.pivotaltracker.com/services/v5/projects/1234567/stories"
        expect(request.valueForHTTPHeaderField("X-TrackerToken")) == "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
        expect(request.valueForHTTPHeaderField("Content-Type")) == "application/json"
        let data = request.HTTPBody ?? request.HTTPBodyStream?.synchronouslyRead()
        let parsedJSON: AnyObject = try! NSJSONSerialization.JSONObjectWithData(data!, options: [])
        expect(parsedJSON.description) == jsonObject("PivotalRequest").description
        expect(request.HTTPMethod) == "POST"
        let response = NSHTTPURLResponse(URL: request.URL!, statusCode: 200, HTTPVersion: nil, headerFields: nil)!
        return .Success(response, jsonData("PivotalResponse"))
    }
    
}