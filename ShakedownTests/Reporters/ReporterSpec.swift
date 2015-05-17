import XCTest
import Quick
import Nimble
import Mockingjay
import ShakedownSample

class ReporterSpec: QuickSpec {
    
    override func spec() {
        // Noop for super class, subclasses do not receive
        if self.isMemberOfClass(ReporterSpec) {
            return
        }
        
        describe("uploader") {
            let instance = self.reporter
            it("is initialized properly") {
                expect(instance).toNot(beNil())
            }
            it("should report issue succesfully") {
                self.stub(everything, builder: self.stubAndVerifyRequest)
                var error: NSError?
                var text: String?
                instance.fileBugReport(TestData.report, imageUploader: NoOpSuccessImageUploader(), logUploader: NoOpSuccessLogUploader(), completion: { (text, error) = ($0, $1) })
                expect(text).toEventually(equal(self.expectedMessage), timeout: 3)
                expect(error).toEventually(beNil(), timeout: 3)
            }
            it("should fail to upload if image upload fails") {
                self.stub(everything, builder: self.stubAndVerifyRequest)
                var error: NSError?
                var text: String?
                instance.fileBugReport(TestData.report, imageUploader: NoOpFailureImageUploader(), logUploader: NoOpSuccessLogUploader(), completion: { (text, error) = ($0, $1) })
                expect(text).toEventually(beNil(), timeout: 3)
                expect(error).toEventuallyNot(beNil(), timeout: 3)
            }
            it("should fail to upload if log upload fails") {
                self.stub(everything, builder: self.stubAndVerifyRequest)
                var error: NSError?
                var text: String?
                instance.fileBugReport(TestData.report, imageUploader: NoOpSuccessImageUploader(), logUploader: NoOpFailureLogUploader(), completion: { (text, error) = ($0, $1) })
                expect(text).toEventually(beNil(), timeout: 3)
                expect(error).toEventuallyNot(beNil(), timeout: 3)
            }
            it("should fail to upload if server returns an error") {
                self.stub(everything, builder: http(status: 500))
                var error: NSError?
                var text: String?
                instance.fileBugReport(TestData.report, imageUploader: NoOpSuccessImageUploader(), logUploader: NoOpSuccessLogUploader(), completion: { (text, error) = ($0, $1) })
                expect(text).toEventually(beNil(), timeout: 3)
                expect(error).toEventuallyNot(beNil(), timeout: 3)
            }
        }

    }
    
    var reporter: Reporter {
        fail("Subclass must override")
        let x: Reporter? = nil
        return x!
    }
    
    var expectedMessage: String {
        fail("Subclass must override")
        return ""
    }
    
    func stubAndVerifyRequest(request: NSURLRequest) -> Response {
        fail("Subclass must override")
        return .Failure(NSError(domain: "ReporterSpecDomain", code: 500, userInfo: nil))
    }
    
}
