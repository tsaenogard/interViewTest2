//
//  DataManager.swift
//  GetData
//
//  Created by XCODE on 2017/2/19.
//  Copyright © 2017年 Xuan. All rights reserved.
//

import UIKit

enum Types: String {
    case csv
    case xml
    case json
    case txt
}

class DataManager: NSObject, XMLParserDelegate {
    //進行資料取回並解析
    //MARK: -解析資料
    func processData(_ data: Data, type: Types) -> String {
        //解析傳回資料
        print(data)
        var resulrString = ""
        switch type {
        case .csv:
            if let csvData = String(data: data, encoding: .utf8) {
                let contentsArray: [String] = csvData.components(separatedBy: CharacterSet.newlines)
                
                var result = [[String]]()
                for value in contentsArray {
                    var tempArray = [String]()
                    tempArray = value.components(separatedBy: ",")
                    result.append(tempArray)
                }
                
                resulrString = "\(result.description)"
                
            }
            print(resulrString)
            print("用csv解析資料成功")
            
        case .json:
            var dataDict: NSDictionary = ["return":"empty"]
            do {
                dataDict = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! NSDictionary
            } catch  {
                print(error)
            }
            
            let response = dataDict.description
            resulrString = response
            print(resulrString)
            print("用json解析資料成功")
            
        case .txt:
            if let txtData = String(data: data, encoding: .utf8) {
                resulrString = txtData
            }
            print(resulrString)
            print("用txt解析資料成功")
            
        case .xml:
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
            resulrString = parseString
            print(resulrString)
            print("用xml解析資料成功")
            
        }
        return resulrString
    }
    
    //MARK: -取回資料
    func getData1(urlString: String,  parameters: [String: Any], method: String, type: Types, completion: @escaping (Any) -> Void) {
        //以JSON傳出login放入key
        
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
        }catch let error{
            print(error)
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") //加入json header
        //request.addValue("login", forHTTPHeaderField: "Key")  //加入login的Key
        
        print("request= \(String(data: request.httpBody!, encoding: .utf8)!)")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if error != nil{
                print(error as Any)
            }else{
                guard let data = data else{return}
                print("response= \(response)")
                completion(self.processData(data, type: type))
            }
        }
        task.resume()
    }
    
    func getData2(urlString: String,  parameters: String, method: String, type: Types, completion: @escaping (Any) -> Void) {
        //以x-www-form-urlencoded傳出login放入key
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        request.httpBody = parameters.data(using: .utf8)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//        request.addValue("login", forHTTPHeaderField: "Key")
        print("request= \(request.allHTTPHeaderFields)")
        
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if error != nil{
                print(error as Any)
            }else{
                guard let data = data else{return}
                print("response= \(response)")
                completion(self.processData(data, type: type))
            }
        }
        task.resume()
    }
    
//    func getData3(urlString: String,  parameters: [String: String], method: String, type: Types, completion: @escaping (Any) -> Void) {
//        //以JSON傳出，key、acc、pwd皆用header傳出
//        let url = URL(string: urlString)!
//        var request = URLRequest(url: url)
//        request.httpMethod = method
//        
//        do{
//            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
//        }catch let error{
//            print(error)
//        }
//        
//        for (key, value) in parameters {
//            request.addValue(value, forHTTPHeaderField: key)
//        }
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("login", forHTTPHeaderField: "Key")
//        print("request= \(request.allHTTPHeaderFields)")
//        
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//            
//            if error != nil{
//                print(error as Any)
//            }else{
//                guard let data = data else{return}
//                print("response= \(response)")
//                completion(self.processData(data, type: type))
//            }
//        }
//        task.resume()
//    }
//    
//    
//    func getData4(urlString: String,  parameters: String, headers: [String: String], method: String, type: Types, completion: @escaping (Any) -> Void) {
//        //以x-www-form-urlencoded傳出，key、acc、pwd皆用header傳出
//        let url = URL(string: urlString)!
//        var request = URLRequest(url: url)
//        request.httpMethod = method
//        
//        request.httpBody = parameters.data(using: .utf8)
//        for (key, value) in headers {
//            request.addValue(value, forHTTPHeaderField: key)
//        }
//        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//        request.addValue("login", forHTTPHeaderField: "Key")
//        print("request= \(request.allHTTPHeaderFields)")
//        
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//            
//            if error != nil{
//                print(error as Any)
//            }else{
//                guard let data = data else{return}
//                print("response= \(response)")
//                completion(self.processData(data, type: type))
//            }
//        }
//        task.resume()
//    }
    
    func getData5(urlString: String,  parameters: [String: String], headers: [String: String] = [:], method: String, type: Types, completion: @escaping (Any) -> Void) {
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        
        request.httpMethod = method
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
            print(request.httpBody)
        } catch {
            print(error)
        }
        
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        print("request = \(request)")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let _ = data, let _ = response, error == nil else{
                print("error = \(error)")
                return
            }
            
            print("response = \(response)")
            completion(self.processData(data!, type: type))
        }
        task.resume()
    }
    
    func  getData6(urlString: String,  parameters: String, method: String, type: Types, completion: @escaping (Any) -> Void) {
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        
        request.httpMethod = method
        
//        do {
//            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
//            print(request.httpBody)
//        } catch {
//            print(error)
//        }
        request.httpBody = parameters.data(using: .utf8)
        
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        print("request = \(request.allHTTPHeaderFields)")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let _ = data, let _ = response, error == nil else{
                print("error = \(error)")
                return
            }
            
            print("response = \(response)")
            completion(self.processData(data!, type: type))
        }
        task.resume()
    }
    
    func getToken1(urlString: String,  parameters: String, method: String, type: Types, completion: @escaping (Any) -> Void) {
        //網路方法1(以base64格式傳出Authorization)
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
        request.addValue("login", forHTTPHeaderField: "Key")
        request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("error=\(error as Any)")
                return
            }
            
            print("response = \(response)")
            guard let data = data else { return }
            completion(self.processData(data, type: type))
        }
        task.resume()
    }

    
    func getToken4(urlString: String, parameters: String, method: String, completion: @escaping (_: Any) -> Void) {
        //網路方法2(用NSMutableURLRequest)
        let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL)
        request.httpMethod = method
        request.httpBody = parameters.data(using: String.Encoding.utf8)
        request.addValue("login", forHTTPHeaderField: "Key")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){data, response, error in
            guard error == nil && data != nil else{
                print("error")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200{
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            let responseString = String(data: data!, encoding: String.Encoding.utf8)
            print("responseString = \(responseString)")
            completion(responseString)
        }
        task.resume()
    }
    
    
    func getToken6(urlString: String, parameters: String, method: String, completion: @escaping (_: Any) -> Void) {
        //網路方法3
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = method
        
        let postString = parameters as NSString
        request.httpBody = postString.data(using: String.Encoding.utf8.rawValue)
        request.addValue("login", forHTTPHeaderField: "Key")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            do {
                let jsonResults: NSDictionary = try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
                print("login json is ---%@",jsonResults)
                
                let str = jsonResults.object(forKey: "status") as! String!
                if str == "Success" {
                    let newdisc: NSDictionary = jsonResults.object(forKey: "response") as! NSDictionary
                    completion(newdisc)
                }}catch {
                    print("Fetch failed: \((error as NSError).localizedDescription)")
            }
        }
        task.resume()
    }
    
    //MARK: -XMLParser
    
    var parseString: String = ""
    var currentParsedName: String = ""
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentParsedName = elementName
        parseString += "\(elementName) : "
        
    }
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        let str = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if str != "" {
            print("\(currentParsedName):\(str)")
        }
        parseString += "\(string)"
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        parseString += "\n"
    }
    
}








