import UIKit
@testable import Shakedown

struct TestData {
    
    static var log: String {
        return "Something happened\nSomething else happened\nA final thing happened"
    }
    
    static var deviceInfo: [String : String] {
        return ["Device": "iPhone 6", "Device Name": "Max's iPhone"]
    }
    
    static var image: UIImage {
        class TestBundleClass {}
        let path = NSBundle(forClass: TestBundleClass.self).pathForResource("TestImage", ofType: "png")
        return UIImage(contentsOfFile: path!)!
    }
    
    static var report: BugReport {
        let report = BugReport(screenshot: image, deviceConfiguration: deviceInfo, deviceLog: log)
        report.title = "Some Test Issue"
        report.description = "This is a decently long description. It spans multiple lines, it also has some \nnewlines dropped in there."
        report.reproducibility = "Always"
        report.reproductionSteps = ["First step", "Second step", "Third step"]
        return report
    }
    
}