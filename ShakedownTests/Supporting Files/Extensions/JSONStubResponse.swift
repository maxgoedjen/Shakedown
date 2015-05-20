import Foundation

func jsonObject(name: String) -> AnyObject {
    return NSJSONSerialization.JSONObjectWithData(jsonData(name), options: nil, error: nil)!
}

func jsonData(name: String) -> NSData {
    let path = NSBundle(forClass: ImageUploaderSpec.self).URLForResource(name, withExtension: "json")
    return NSData(contentsOfURL: path!)!
}
