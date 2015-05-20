import UIKit

@objc public class BugReport {
    
    public var title = ""
    public var description = ""
    public var reproducibility = ""
    public var reproductionSteps: [String] = []
    public var deviceLog: String
    public let screenshot: UIImage
    public let deviceConfiguration: [String : String]
    
    public init(screenshot: UIImage, deviceConfiguration: [String : String], deviceLog: String?) {
        self.screenshot = screenshot
        self.deviceConfiguration = deviceConfiguration
        self.deviceLog = deviceLog?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) ?? ""
        self.reproducibility = Shakedown.configuration.reproducibilityOptions.first!
    }
    
}