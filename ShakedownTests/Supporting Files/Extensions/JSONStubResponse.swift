import Foundation

func jsonObject(name: String) -> AnyObject {
    return try! NSJSONSerialization.JSONObjectWithData(jsonData(name), options: [])
}

func jsonData(name: String) -> NSData {
    let path = NSBundle(forClass: ImageUploaderSpec.self).URLForResource(name, withExtension: "json")
    return NSData(contentsOfURL: path!)!
}
