import Foundation

extension NSInputStream {
    
    func synchronouslyRead() -> NSData {
        open()
        var buffer: [UInt8] = []
        while hasBytesAvailable {
            var local = [UInt8](count: 1024, repeatedValue: 0)
            let readCount = read(&local, maxLength: 1024)
            buffer += local[0..<readCount]
        }
        close()
        return NSData(bytes: &buffer, length: buffer.count)
    }
    
}