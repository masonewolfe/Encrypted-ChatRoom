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
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let parameters = parameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            completion(data, response, error)
        }
        task.resume()
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

