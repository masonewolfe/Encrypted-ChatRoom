//
//  HTTPController.swift
//  Non-Persistent E2E Messaging
//
//  Created by Dylan Moran on 2/21/23.
//

import Foundation

class HTTPController {
    
    let serverURL: String
    
    init(serverURL: String){
        self.serverURL = serverURL
    }
    
    func sendRequest(path: String, method: String, parameters: [String: Any]?, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let url = URL(string: serverURL + path) else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        if let parameters = parameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        }
        
    
    }
    
        func post(path: String, parameters: [String: Any]?, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
           sendRequest(path: path, method: "POST", parameters: parameters, completion: completion)
       }
       
       func put(path: String, parameters: [String: Any]?, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
           sendRequest(path: path, method: "PUT", parameters: parameters, completion: completion)
       }
       
       func get(path: String, parameters: [String: Any]?, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
           sendRequest(path: path, method: "GET", parameters: parameters, completion: completion)
       }
       
       func delete(path: String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
           sendRequest(path: path, method: "DELETE", parameters: nil, completion: completion)
       }
    
}

/**let http = HTTPController(serverURL: "http://52.188.65.46:5000/")
 let json: [String : Any] = ["username": "jordan"]
 http.get(path: "pull", parameters: json){ data, response, error in
     if let error = error {
         // Handle any errors that occurred
         print("Error fetching users: \(error)")
         return
     }
     
     if let data = data {
         // Parse the JSON response data, if any
         if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
             print("Fetched users: \(json)")
         } else {
             print("Unable to parse response data as JSON")
         }
     } else {
         print("No data returned from server")
     }
 }*/
