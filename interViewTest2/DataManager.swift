//
//  DataManager.swift
//  GetData
//
//  Created by XCODE on 2017/2/19.
//  Copyright © 2017年 Xuan. All rights reserved.
//

import UIKit

class DataManager: NSObject {
    
    func getToken(urlString: String,  parameters: String, method: String, completion: @escaping (Data) -> Void) {
        
        let url = URL(string: urlString)!
        let data = parameters.data(using: .utf8)!
        let base64LoginString = data.base64EncodedString()
        let postLength = NSString(format: "%ld", (data as NSData).length)
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = data
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("Basic " + base64LoginString, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("error=\(error as Any)")
                return
            }
            
            print("response = \(response)")
            guard let data = data else { return }
            completion(data)
        }
        task.resume()
    }
    
    func getToken2(urlString: String,  parameters: String, method: String, completion: @escaping (Data) -> Void) {
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = method
        let postString = parameters
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
        }
        task.resume()

    }
}






