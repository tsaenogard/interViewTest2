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
        var request = URLRequest(url: url)
        request.httpMethod = method

        request.httpBody = parameters.data(using: .utf8)
        
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("error=\(error as Any)")
                return
            }
            guard let data = data else { return }
            completion(data)
        }
        task.resume()
    }
}
