import XCTest
import CoreGraphics
import Quick
import Nimble
import Mockingjay
import ShakedownSample

class LogUploaderSpec: QuickSpec, UploaderSpec {
    
    override func spec() {
        // Noop for super class, subclasses do not receive
        if self.isMemberOfClass(LogUploaderSpec) {
            return
        }
        
        describe("uploader") {
            let instance = self.uploader
            it("is initialized properly") {
                expect(instance).toNot(beNil())
            }
            let (log, metadata) = (TestData.log, TestData.deviceInfo)
            it("should upload successfully") {
                var url: NSURL?
                var error: NSError?
                self.stub(everything, builder: self.stubAndVerifyRequest)
                instance.uploadLog(log, deviceConfiguration: metadata) { (url, error) = ($0, $1) }
                expect(url).toEventually(equal(self.expectedURL), timeout: 3)
                expect(error).toEventually(beNil(), timeout: 3)
            }
            it("should report an error if server returns an error") {
                var url: NSURL?
                var error: NSError?
                self.stub(everything, builder: http(status: 500))
                instance.uploadLog(log, deviceConfiguration: metadata) { (url, error) = ($0, $1) }
                expect(url).toEventually(beNil(), timeout: 3)
                expect(error).toEventuallyNot(beNil(), timeout: 3)
            }
        }
    }
    
    func stubAndVerifyRequest(request: NSURLRequest) -> Response {
        return .Failure(NSError(domain: "ReporterSpecDomain", code: 500, userInfo: nil))
    }
    
    var expectedURL: NSURL {
        return NSURL()
    }
    
    var uploader: LogUploader {
        return NoOpFailureLogUploader()
    }
    
}

