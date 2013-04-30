//
//  SHDXMLReader.h
//  Shakedown
//
//  Adapted from https://github.com/genkernel/XML-to-NSDictionary
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
// 
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
// 
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

//
// http://troybrant.net/blog/2010/09/simple-xml-to-nsdictionary-converter/
//
// Parse the XML into a dictionary
// NSError *parseError = nil;
// NSDictionary *xmlDictionary = [SHDXMLReader dictionaryForXMLString:testXMLString error:&parseError];
// 
// // Print the dictionary
// NSLog(@"%@", xmlDictionary);
//
// testXMLString = 
//    <items>
//        <item id=”0001″ type=”donut”>
//            <name>Cake</name>
//            <ppu>0.55</ppu>
//            <batters>
//                <batter id=”1001″>Regular</batter>
//                <batter id=”1002″>Chocolate</batter>
//                <batter id=”1003″>Blueberry</batter>
//            </batters>
//            <topping id=”5001″>None</topping>
//            <topping id=”5002″>Glazed</topping>
//            <topping id=”5005″>Sugar</topping>
//        </item>
//    </items>
//
// is converted into
//
// xmlDictionary = {
//     items = {
//         item = {
//             attributes = {
//                 id = 0001;
//                 type = donut;
//             },
//             name = {
//                 text = Cake;
//             };
//             ppu = {
//                 text = 0.55;
//             };
//             batters = {
//                 batter = (
//                 {
//                     attributes = {
//                         id = 1001;
//                     },
//                     text = Regular;
//                 },
//                 {
//                     attributes = {
//                         id = 1002;
//                     },
//                     text = Chocolate;
//                 },
//                 {
//                     attributes = {
//                         id = 1003;
//                     },
//                     text = Blueberry;
//                 }
//                 );
//             };
//             topping = (
//             {
//                 attributes = {
//                     id = 5001;
//                 },
//                 text = None;
//             },
//             {
//                 attributes = {
//                     id = 5002;
//                 },
//                 text = Glazed;
//             },
//             {
//                 attributes = {
//                     id = 5005;
//                 },
//                 text = Sugar;
//             }
//             );
//         };
//     };
// }


@interface SHDXMLReader : NSObject<NSXMLParserDelegate>

+ (NSDictionary *)dictionaryForXMLData:(NSData *)data error:(NSError **)error;
+ (NSDictionary *)dictionaryForXMLString:(NSString *)string error:(NSError **)error;

@end

extern NSString * const kSHDXMLReaderAttributesNodeKey = @"attributes";
extern NSString * const kSHDXMLReaderTextNodeKey = @"text";
