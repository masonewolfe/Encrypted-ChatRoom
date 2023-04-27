//
//  CommonCrypto.swift
//  Non-Persistent E2E Messaging
//
//  Created by Dylan Moran on 4/10/23.
//

import Foundation
import CommonCrypto

extension Data {
    func aesEncrypt(key: Data, iv: Data) -> Data? {
        return crypt(operation: CCOperation(kCCEncrypt), key: key, iv: iv)
    }
    
    func aesDecrypt(key: Data, iv: Data) -> Data? {
        return crypt(operation: CCOperation(kCCDecrypt), key: key, iv: iv)
    }
    
    private func crypt(operation: CCOperation, key: Data, iv: Data) -> Data? {
        let cryptLength = self.count + kCCBlockSizeAES128
        var cryptData = Data(count: cryptLength)
        
        print("CommonCrypto;crypt;24; key + length: \(key.count)\n\(key)\n")
        print("CommonCrypto;crypt;25; iv + length: \(iv.count)\n\(iv)\n")
        
        
        let keyLength = key.count
        let options = CCOptions(kCCOptionPKCS7Padding)
        var numBytesCrypt = 0
        
        let cryptStatus = cryptData.withUnsafeMutableBytes { cryptBytes in
            self.withUnsafeBytes { dataBytes in
                key.withUnsafeBytes { keyBytes in
                    iv.withUnsafeBytes { ivBytes in
                        CCCrypt(operation, CCAlgorithm(kCCAlgorithmAES), options, keyBytes.baseAddress, keyLength, ivBytes.baseAddress, dataBytes.baseAddress, self.count, cryptBytes.baseAddress, cryptLength, &numBytesCrypt)
                    }
                }
            }
        }
        
        if UInt32(cryptStatus) == UInt32(kCCSuccess) {
            cryptData.removeSubrange(numBytesCrypt..<cryptData.count)
            return cryptData
        } else {
            return nil
        }
    }
}

