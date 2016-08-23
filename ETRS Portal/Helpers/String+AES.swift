//
//  String+AES.swift
//  ETRS
//
//  Created by BBaoBao on 9/20/15.
//  Copyright © 2015 buingocbao. All rights reserved.
//

import Foundation
import CryptoSwift

//Security functions
extension String {
    
    func aesEncrypt(key: [UInt8], iv: [UInt8]) -> String {
        let data = self.dataUsingEncoding(NSUTF8StringEncoding)
        do {
            let enc = try AES(key: key, iv: iv, blockMode:.CBC)!.encrypt(data!.arrayOfBytes(), padding: PKCS7())
            let encData = NSData(bytes: enc, length: Int(enc.count))
            let base64String: String = encData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0));
            let result = String(base64String)
            return result
        } catch {
            print(error)
            return ""
        }
    }
    
    func aesDecrypt(key: [UInt8], iv: [UInt8]) -> String {
        let data = NSData(base64EncodedString: self, options: NSDataBase64DecodingOptions(rawValue: 0))
        do {
            if data == nil {
                return "WARNING"
            } else {
                let dec = try AES(key: key, iv: iv, blockMode:.CBC)!.decrypt(data!.arrayOfBytes(), padding: PKCS7())
                let decData = NSData(bytes: dec, length: Int(dec.count))
                let result = NSString(data: decData, encoding: NSUTF8StringEncoding)
                return String(result!)
            }
        } catch {
            print(error)
            return ""
        }
    }
}