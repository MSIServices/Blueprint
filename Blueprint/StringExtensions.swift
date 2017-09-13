//
//  StringExtensions.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 7/29/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import Foundation
import CryptoSwift
import UIKit

/*........................................................................................................................................................................................................
 INSTANCE METHODS
 ........................................................................................................................................................................................................*/
extension String {
    
    func toBytes() -> [UInt8] {
        
        let hexa = Array(characters)
        return stride(from: 0, to: characters.count, by: 2).flatMap { UInt8(String(hexa[$0..<$0.advanced(by: 2)]), radix: 16) }
    }
    
    func aesEncrypt(key: Array<UInt8>, iv: Array<UInt8>) throws -> String {
        
        let data = self.data(using: String.Encoding.utf8)
        let enc = try AES(key: key, iv: iv, blockMode: .CBC, padding: PKCS7()).encrypt(data!.bytes)
        let encData = NSData(bytes: enc, length: Int(enc.count))
        let base64String: String = encData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        
        return String(base64String)
    }
    
    func aesDecrypt(key: Array<UInt8>, iv: Array<UInt8>) throws -> String {
        
        let data = Data(base64Encoded: self, options: NSData.Base64DecodingOptions(rawValue: 0))
        let dec = try AES(key: key, iv: iv, blockMode: .CBC, padding: PKCS7()).decrypt(data!.bytes)
        let decData = NSData(bytes: dec, length: Int(dec.count))
        let result = NSString(data: decData as Data, encoding: String.Encoding.utf8.rawValue)
        
        return String(result!)
    }

    func isValidEmail() -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func isValidUrl() -> Bool {
        
        if let url = URL(string: self) {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
    
    func isAlphaNumeric() -> Bool {
        
        let alphaNumericChars: NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        for char in self.characters {

            if !alphaNumericChars.contains("\(char)") {
                return false
            }
        }
        return true
    }
    
    func countAlphaNumericChars() -> Int {
        
        let alphaNumericChars: NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var numOfAlphaNumericChars = 0
        
        for char in self.characters {
            
            if alphaNumericChars.range(of: String(char)).location != NSNotFound {
                numOfAlphaNumericChars += 1
            }
        }
        return numOfAlphaNumericChars
    }
    
    func height(width: CGFloat, font: UIFont) -> CGFloat {
        
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(height: CGFloat, font: UIFont) -> CGFloat {
        
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
}

/*........................................................................................................................................................................................................
 STATIC METHODS
 ........................................................................................................................................................................................................*/
extension String {
    
    static func randomAlphaNum(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
    
}

/*........................................................................................................................................................................................................
 MUTATING METHODS
 ........................................................................................................................................................................................................*/
extension String {
    
    mutating func prepend(_ string: String) {
        self = string + self
    }
    
    mutating func microsoftSqltoDate() -> Date? {
        
        let dateFormatter = DateFormatter()
        
        var date: Date?
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZZZZZ"
        
        if let microsoftSqlServerDate = dateFormatter.date(from: self) {
            date = microsoftSqlServerDate
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        
        if let microsoftSqlServerDate = dateFormatter.date(from: self) {
            date = microsoftSqlServerDate
        }
        return date
    }
    
    mutating func sqlToDate() -> Date {
        
        let dateFormatter = DateFormatter()
        
        self.trimAfter(char: ".")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        return dateFormatter.date(from: self)!
    }
    
    mutating func convertToValidUrlString() -> String {
        
        if !self.contains("http") {
            self.prepend("http://")
        }
        return self
    }
    
    mutating func trimBefore(char: Character) {
        
        if let charRange = self.range(of: String(char)) {
            self.removeSubrange(self.startIndex..<charRange.upperBound)
        }
    }
    
    mutating func trimAfter(char: Character) {
        
        if let charRange = self.range(of: String(char)) {
            self.removeSubrange(charRange.lowerBound..<self.endIndex)
        }
    }

}
