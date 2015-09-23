import XCTest
import CoreGraphics
import Quick
import Nimble
import Mockingjay
@testable import Shakedown

class ImgurUploaderSpec: ImageUploaderSpec {

    override var uploader: ImageUploader {
        return ImgurUploader(clientID: "TestClientID")
    }
    
    override var expectedURL: NSURL {
        return NSURL(string: "http://i.imgur.com/HV2zEeU.png")!
    }
    
    override func stubAndVerifyRequest(request: NSURLRequest) -> Response {
        let image = UIImage(data: request.HTTPBodyStream!.synchronouslyRead())
        expect(UIImagePNGRepresentation(image!)) == UIImagePNGRepresentation(TestData.image)
        expect(request.URL!.absoluteString) == "https://api.imgur.com/3/image"
        expect(request.valueForHTTPHeaderField("Authorization")) == "Client-ID TestClientID"
        expect(request.HTTPMethod) == "POST"
        let response = NSHTTPURLResponse(URL: request.URL!, statusCode: 200, HTTPVersion: nil, headerFields: nil)!
        return .Success(response, jsonData("ImgurResponse"))
    }
    
}
