//
//  SwiftRegex.swift
//  SwiftRegex
//
//  Created by Gregory Todd Williams on 6/7/14.
//  Copyright (c) 2014 Gregory Todd Williams. All rights reserved.
//

import Foundation

//extension String {
//    func rangeFromNSRange(nsRange : NSRange) -> Range<String.Index>? {
//        let from16 = utf16.startIndex.advancedBy(nsRange.location, limit: utf16.endIndex)
//        let to16 = from16.advancedBy(nsRange.length, limit: utf16.endIndex)
//        if let from = String.Index(from16, within: self),
//            let to = String.Index(to16, within: self) {
//                return from ..< to
//        }
//        return nil
//    }
//}
//
//
//extension String {
//    func NSRangeFromRange(range : Range<String.Index>) -> NSRange {
//        let utf16view = self.utf16
//        let from = String.UTF16View.Index(range.startIndex, within: utf16view)
//        let to = String.UTF16View.Index(range.endIndex, within: utf16view)
//        return NSMakeRange(utf16view.startIndex.distanceTo(from), from.distanceTo(to))
//    }
//}

infix operator =~ {}

func =~ (value : String, pattern : String) -> RegexMatchResult {
    let nsstr = value as NSString // we use this to access the NSString methods like .length and .substringWithRange(NSRange)
    let options : NSRegularExpressionOptions = []
    do {
        let re = try  NSRegularExpression(pattern: pattern, options: options)
        let all = NSRange(location: 0, length: nsstr.length)
        var matches : Array<String> = []
        var captureResult : [RegexCaptureResult] = [RegexCaptureResult]()
        re.enumerateMatchesInString(value, options: [], range: all) { (result, flags, ptr) -> Void in
            guard let result = result else { return }
            var captureItems : [String] = []

            for i in 0..<result.numberOfRanges
            {
                let range = result.rangeAtIndex(i)
                print(range)
                let string = nsstr.substringWithRange(range)
                if(i > 0) {
                    captureItems.append(string)
                    continue
                }
                
                matches.append(string)
            }
            captureResult.append(RegexCaptureResult(items: captureItems))

            print(matches)

        }
        
        return RegexMatchResult(items: matches, captureItems: captureResult)
    } catch {
        return RegexMatchResult(items: [], captureItems: [])
    }
}

struct RegexMatchCaptureGenerator : GeneratorType {
    var items: Array<String>
    mutating func next() -> String? {
        if items.isEmpty { return nil }
        let ret = items[0]
        items = Array(items[1..<items.count])
        return ret
    }
}

struct RegexMatchResult : SequenceType, BooleanType {
    var items: Array<String>
    var captureItems: [RegexCaptureResult]
    func generate() -> RegexMatchCaptureGenerator {
        print(items)
        return RegexMatchCaptureGenerator(items: items)
    }
    var boolValue: Bool {
        return items.count > 0
    }
    subscript (i: Int) -> String {
        return items[i]
    }
    
}

struct RegexCaptureResult {
    var items: Array<String>
}
class SwiftRegex {
    //是否包含
    class func containsMatch(pattern: String, inString string: String) -> Bool {
        let options : NSRegularExpressionOptions = []
        let matchOptions : NSMatchingOptions = []
        
        let regex = try! NSRegularExpression(pattern: pattern, options: options)
        let range = NSMakeRange(0, string.characters.count)
        return regex.firstMatchInString(string, options: matchOptions, range: range) != nil
    }
    
    //匹配
    class func match(pattern: String, inString string: String) -> RegexMatchResult {
        return string =~ pattern
    }
    //替换
    class func replaceMatches(pattern: String, inString string: String, withString replacementString: String) -> String? {
        let options : NSRegularExpressionOptions = []
        let matchOptions : NSMatchingOptions = []
        
        let regex = try! NSRegularExpression(pattern: pattern, options: options)
        let range = NSMakeRange(0, string.characters.count)
        
        
        return regex.stringByReplacingMatchesInString(string, options: matchOptions, range: range, withTemplate: replacementString)
    }
}


