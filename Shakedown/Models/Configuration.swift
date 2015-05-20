import Foundation

@objc public class Configuration {
    
    public var reporter: Reporter?
    public var imageUploader: ImageUploader = ImgurUploader()
    public var logUploader: LogUploader = GistUploader()
    public var reproducibilityOptions = ["Every Time", "Sometimes", "Rarely"]
    public var additionalMetadata: [String : String] = [:]
    
    var log: String = ""
    
    init() {
    }

}
