import Foundation
import Mockingjay

protocol UploaderSpec {
    var expectedURL: NSURL { get }
    func stubAndVerifyRequest(request: NSURLRequest) -> Response
}