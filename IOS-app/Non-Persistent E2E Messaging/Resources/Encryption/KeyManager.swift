//
//  GenerateKeyPairs.swift
//  Non-Persistent E2E Messaging
//
//  Created by Dylan Moran on 3/16/23.
//

import Foundation
import Security
import CommonCrypto
import UIKit
import CoreData
import SwiftyRSA

class KeyManager{
    
    //Allows for usage throughout code without creating new instances
    
    static let shared = KeyManager()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //########################################################################//
    
    //Function to generate key pair for users
    
    func generateRSA(privateKeyTag: String) -> (privateKey: SecKey?, publicKey: SecKey?, publicKeyBase64: String?) {
        let privateKeyAttributes: [String: Any] = [
            kSecAttrIsPermanent as String: true,
            kSecAttrApplicationTag as String: privateKeyTag.data(using: .utf8)!,
        ]
        
        let parameters: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeySizeInBits as String: 1024,
            kSecPrivateKeyAttrs as String: privateKeyAttributes,
        ]
        
        var privateKey: SecKey?
        let status = SecKeyGeneratePair(parameters as CFDictionary, nil, &privateKey)
        
        if status != errSecSuccess {
            print("Error generating key pair: \(status)")
            return (nil, nil, nil)
        }
        
        var publicKey: SecKey?
        var publicKeyBase64: String?
        
        if let privateKey = privateKey{
            publicKey = SecKeyCopyPublicKey(privateKey)
            if let publicKeyData = getPublicKeyData(publicKey: publicKey!) {
                        publicKeyBase64 = publicKeyData.base64EncodedString()
                    }
        }
        print("Public Key: \(String(describing: publicKey))")
        print("Private Key: \(String(describing: privateKey))")
        print("Encoded Public Key: \(String(describing: publicKeyBase64))")
        return (publicKey, privateKey, publicKeyBase64)
    }
    
    //########################################################################//
    
    func generateAES() -> Data? {
        let keyLength = 16 // Change this value to 16 bytes for AES-128
        var keyData = Data(count: keyLength)
        
        let result = keyData.withUnsafeMutableBytes {
            SecRandomCopyBytes(kSecRandomDefault, keyLength, $0.baseAddress!)
        }
        
        if result == errSecSuccess {
            return keyData
        } else {
            print("Error generating AES-128 key: \(result)")
            return nil
        }
    }

    
    //########################################################################//
    
    //Function to retrieve users public keys from the server via http request
    
    func getKey(username: String, completion: @escaping (SecKey?) -> Void) {
        
        let url = URL(string: "http://3.91.204.251:5000/pull")!
        var request = URLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["username" : username]
        let bodyData = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        request.httpMethod = "POST"
        request.httpBody = bodyData
        
        let session = URLSession.shared
        let task = session.dataTask(with: request){ (data, response, error)  in
            
            guard let data = data, error == nil else {
                   print(error?.localizedDescription ?? "No data")
                    completion(nil)
                    return
               }
            
            //Commented lines are to print the entire json response
            
             /*  let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
               if let responseJSON = responseJSON as? [String: Any] {
                   print(responseJSON)
               }*/
            
            if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                if let publicKey = jsonObject["publicKey"] as? String {
                    let keyData = Data(base64Encoded: publicKey)
                    let key = self.decodePublicKeyData(keyData: keyData!)
                    completion(key)
                }
            }
        }
        
        task.resume()
    }
    
    func getPrivateKeyFromKeychain(privateKeyTag: String) -> SecKey? {
            let query: [String: Any] = [
                kSecClass as String: kSecClassKey,
                kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
                kSecAttrKeyClass as String: kSecAttrKeyClassPrivate,
                kSecAttrApplicationTag as String: privateKeyTag.data(using: .utf8)!,
                kSecReturnRef as String: true
            ]

            var keyRef: AnyObject?
            let status = SecItemCopyMatching(query as CFDictionary, &keyRef)

            if status == errSecSuccess {
                return keyRef as! SecKey?
            } else {
                print("Error retrieving private key from keychain")
                return nil
            }
        }
    
    //########################################################################//
    
    //Takes data of public key from server and converts it into a usable public key object
    
    func decodePublicKeyData(keyData: Data) -> SecKey? {

        let keyDict: [NSString: Any] = [
            kSecAttrKeyType: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass: kSecAttrKeyClassPublic,
            kSecAttrKeySizeInBits: 1024,
            kSecReturnPersistentRef: true
        ]

        var error: Unmanaged<CFError>?
        let publicKey = SecKeyCreateWithData(keyData as CFData, keyDict as CFDictionary, &error)
        if let error = error {
            print("Error importing public key: \(error.takeRetainedValue())")
            return nil
        }
        return publicKey
    }
    
    //########################################################################//
    
    //Function to encrypt message data with users public key
    //returns encrypted message as Data
    
    func RSAencryptMessage(message: String, publicKey: SecKey) -> Data? {
        guard let messageData = message.data(using: .utf8) else {
            print("Error converting message to Data")
            return nil
        }

        let algorithm: SecKeyAlgorithm = .rsaEncryptionPKCS1

        guard SecKeyIsAlgorithmSupported(publicKey, .encrypt, algorithm) else {
            print("Error: encryption algorithm not supported")
            return nil
        }

        var error: Unmanaged<CFError>?
        let encryptedData = SecKeyCreateEncryptedData(publicKey, algorithm, messageData as CFData, &error)
        if let error = error {
            print("Error encrypting message: \(error.takeRetainedValue())")
            return nil
        }

        return encryptedData as Data?
    }
    
    //########################################################################//
    
    func generateRandomBytes(length: Int) -> Data? {
        var data = Data(count: length)
        let result = data.withUnsafeMutableBytes {
            SecRandomCopyBytes(kSecRandomDefault, length, $0.baseAddress!)
        }
        return result == errSecSuccess ? data : nil
    }

    //########################################################################//
 
    func AESencryptMessage(username: String, message: String) -> Data? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<FriendRequest> = FriendRequest.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@", username)
        
        do {
            let fetchedRequests = try context.fetch(fetchRequest)
            
            if let friendRequest = fetchedRequests.first {
                if let base64EncodedAESKey = friendRequest.base64EncodedEncryptedAESKey,
                   let keyData = Data(base64Encoded: base64EncodedAESKey),
                   let ivString = friendRequest.iv,
                   let ivData = Data(base64Encoded: ivString) {
                    
                    guard let messageData = message.data(using: .utf8) else {
                        print("Error converting message to Data")
                        return nil
                    }
                    
                    let encryptedData = messageData.aesEncrypt(key: keyData, iv: ivData)
                    
                    if encryptedData == nil {
                        print("Error encrypting message")
                    }
                    
                    return encryptedData
                    
                } else {
                    print("Error getting key or iv from FriendRequest")
                    return nil
                }
            } else {
                print("No FriendRequest found for the given username")
                return nil
            }
        } catch {
            print("Error fetching FriendRequest from Core Data")
            return nil
        }
    }

    
    //########################################################################//
    
    func encryptAESKey(aesKey: Data, withRSAKey username: String, completion: @escaping (Data?) -> Void) {
        getKey(username: username) { rsaPublicKey in
            guard let rsaPublicKey = rsaPublicKey else {
                print("Error retrieving RSA public key")
                completion(nil)
                return
            }
            
            let algorithm: SecKeyAlgorithm = .rsaEncryptionPKCS1
            
            guard SecKeyIsAlgorithmSupported(rsaPublicKey, .encrypt, algorithm) else {
                print("Error: encryption algorithm not supported")
                completion(nil)
                return
            }
            
            var error: Unmanaged<CFError>?
            let encryptedAESKeyData = SecKeyCreateEncryptedData(rsaPublicKey, algorithm, aesKey as CFData, &error)
            
            if let error = error {
                print("Error encrypting AES key: \(error.takeRetainedValue())")
                completion(nil)
                return
            }
            
            completion(encryptedAESKeyData as Data?)
        }
    }
    
    //########################################################################//
    
    //Function to convert public key to PEM format for universal usage between Android and iOS
    
    func getPublicKeyData(publicKey: SecKey) -> Data? {
        let publicKeyData = SecKeyCopyExternalRepresentation(publicKey, nil) as Data?
        guard let pubKeyData = publicKeyData else {
            return nil
        }
        
        let publicKeyWithSPKIHeader: NSMutableData = NSMutableData()
        
        let spkiHeader: [UInt8] = [0x30, 0x81, 0x9F, 0x30, 0x0D, 0x06, 0x09, 0x2A, 0x86, 0x48, 0x86, 0xF7, 0x0D, 0x01, 0x01, 0x01, 0x05, 0x00, 0x03, 0x81, 0x8D, 0x00]
        publicKeyWithSPKIHeader.append(spkiHeader, length: spkiHeader.count)
        publicKeyWithSPKIHeader.append(pubKeyData as Data)
        
        return publicKeyWithSPKIHeader as Data
    }
    
    //########################################################################//
    
    //Function to decrypt messages by getting private key from local storage and decrypting message data
    
    func decryptMessageWithRSA(encryptedData: Data, privateKeyTag: String) -> String? {
        
        // Retrieve private key from keychain
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: privateKeyTag.data(using: .utf8)!,
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecReturnRef as String: true
        ]

        var keyRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &keyRef)

        guard status == errSecSuccess else {
            print("Error retrieving private key from keychain")
            return nil
        }

        let privateKey = keyRef as! SecKey
        let algorithm: SecKeyAlgorithm = .rsaEncryptionPKCS1

        guard SecKeyIsAlgorithmSupported(privateKey, .decrypt, algorithm) else {
            print("Error: decryption algorithm not supported")
            return nil
        }

        var error: Unmanaged<CFError>?
        let decryptedData = SecKeyCreateDecryptedData(privateKey, algorithm, encryptedData as CFData, &error)
        if let error = error {
            print("Error decrypting message: \(error.takeRetainedValue())")
            return nil
        }

        return String(data: decryptedData! as Data, encoding: .utf8)
    }
    
    //########################################################################//

    func decryptMessageWithAES(messageData: Data, sender: String) -> String? {

        var base64EncodedAESKey: String?
        var base64IV: String?
        
        do{
            let friendReqs = try context.fetch(FriendRequest.fetchRequest())
            
            for reqs in friendReqs {
                print("371; \(reqs.base64EncodedEncryptedAESKey!)")
                if  reqs.username == sender {
                    base64EncodedAESKey = reqs.base64EncodedEncryptedAESKey
                    base64IV = reqs.iv
                }
            }
        }
        catch{
            print("Error fetching friend request data")
        }
        
        let decodedAESKeyData = Data(base64Encoded: base64EncodedAESKey!)
        print("383; \(decodedAESKeyData!)")
        
        let ivData = Data(base64Encoded: base64IV!)

        // Step 5: Decrypt the message using the decoded AES key and IV
        guard let AESKey = decodedAESKeyData as Data?,
              let decryptedMessage = messageData.aesDecrypt(key: AESKey, iv: ivData!) else {
                print("Error decrypting message with AES")
                return nil
        }
        // Step 6: Return the decrypted message as a string
        let decryptedMessageString = String(data: decryptedMessage, encoding: .utf8)
        return decryptedMessageString
    }
    
    //########################################################################//


    func decryptAESKeyWithRSA(privateKey: SecKey, encryptedAESKeyData: Data) -> Data? {
        do {
            let privateKey = try PrivateKey(reference: privateKey)
            let encryptedAESKey = EncryptedMessage(data: encryptedAESKeyData)
            let clearAESKey = try encryptedAESKey.decrypted(with: privateKey, padding: .PKCS1)
            
            // Extract the Data object from the ClearMessage object
            let decryptedAESKeyData = clearAESKey.data
            
            return decryptedAESKeyData
        } catch {
            print("Error decrypting AES key with RSA: \(error)")
            return nil
        }
    }

    //########################################################################//
    
    //Function to post users public key by sending http request to server containing json body [username,email(optional),publickey]
    
    func sendKey(user: String, publicKeyEncoded: String){
        
        let apiUrl = "http://3.91.204.251:5000"
        let httpController = HTTPController(serverURL: apiUrl)
        
        let path = "/create"
        let parameters: [String: Any] = [
            "username": "\(user)",
            "email": "a",
            "publickey": "\(publicKeyEncoded)"
        ]
        httpController.post(path: path, parameters: parameters) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            if let httpResponse = response as? HTTPURLResponse{
                print("HTTP response code: \(httpResponse.statusCode)")
            }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("HTTP response code: \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Public Key sent: \(responseString)")
                }else{
                    print("Error sending public key")
                }
            }
        }
    }
    
    //########################################################################//
    
    func deletePrivateKeyFromKeychain(privateKeyTag: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass as String: kSecAttrKeyClassPrivate,
            kSecAttrApplicationTag as String: privateKeyTag.data(using: .utf8)!,
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        if status == errSecSuccess {
            print("Private key deleted successfully.")
            return true
        } else {
            print("Error deleting private key: \(status)")
            return false
        }
    }
    
    //################################################################################################################################################//
}
