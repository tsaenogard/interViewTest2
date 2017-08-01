//
//  SelectTableViewController.swift
//  interViewTest2
//
//  Created by Eric Chen on 2017/6/28.
//  Copyright © 2017年 MasB1ue. All rights reserved.
//

import UIKit
import Alamofire

class SelectTableViewController: UITableViewController, XMLParserDelegate {
    //印出選單，viewController會將帳密傳至這個頁面
    var segment: UISegmentedControl!
    let typeArray = [Types.csv, Types.xml, Types.json, Types.txt]
    
    var userName: String = ""
    var passWord: String = ""
    
    var functionArray = [
    "以JSON傳資料","以x-www-form-urlencoded傳資料","網路方法一","網路方法二","網路方法三","Alamofire normal","Alamofire authenticate","final","final finally"
    ]
    
    func printResult(_ result: String) {
        
        let destinationVC = ResultViewController()
        destinationVC.str = result
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    
    func printResult2(_ strs: String...) {
        var tempStr = ""
        for str in strs {
            tempStr += str
            tempStr += "\n"
        }
        let destinVC = ResultViewController()
        destinVC.str = tempStr
        self.navigationController?.pushViewController(destinVC, animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return functionArray.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let subView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60))
        subView.backgroundColor = UIColor.white
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30)
        titleLabel.font = UIFont.systemFont(ofSize: titleLabel.frame.height * 0.9)
        titleLabel.textAlignment = .left
        titleLabel.textColor = UIColor.darkGray
        titleLabel.text = "資料傳回型態:"
        subView.addSubview(titleLabel)
        
        self.segment = UISegmentedControl(items: typeArray.map({ (type) -> String in
            type.rawValue
        }))
        self.segment.frame = CGRect(x: 0, y: 30, width: UIScreen.main.bounds.width, height: 30)
        self.segment.selectedSegmentIndex = 2
        subView.addSubview(segment)
        return subView
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        }

         cell?.textLabel?.text = functionArray[indexPath.row]

        return cell!
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = "http://104.199.124.23/bb/iapi/R1.php"
        
        var postString1 = ""
        postString1 += "acc=\(userName)"
        postString1 += "&pwd=\(passWord)"
        //print(postString1)
        
        let postString2 = [
            "acc": "\(userName)",
            "pwd": "\(passWord)"
        ]
        
        let postString3 = "acc:\(userName)&pwd:\(passWord)"
        
        let postString4 = "[\"login\":{\"acc\":\"user01\",\"pwd\":\"1a2b3cd4\"}]"
        
        let postString5 = ["login":["acc":"user01","pwd":"1a2b3cd4"]]
        
        let postString6 = ["login": "{\"acc\":\"user01\",\"pwd\":\"1a2b3cd4\"}"]
        
        let header = ["Key": "login"]
        
        switch indexPath.row {
            
        case 0:
            DataManager().getData1(urlString: url, parameters: postString6, method: "POST", type: self.typeArray[self.segment.selectedSegmentIndex], completion: { (dta) in
                DispatchQueue.main.async {
                    self.printResult(dta as! String)
                }
            })
            
        case 1:
            DataManager().getData2(urlString: url, parameters: postString4, method: "POST", type: self.typeArray[self.segment.selectedSegmentIndex], completion: { (data) in
                DispatchQueue.main.async {
                    self.printResult(data as! String)
                }
            })
            
        case 2:
//            DataManager().getData3(urlString: url, parameters: postString2, method: "POST", type: self.typeArray[self.segment.selectedSegmentIndex], completion: { (dta) in
//                DispatchQueue.main.async {
//                    self.printResult(dta as! String)
//                }
//            })
            break
        case 3:
//            DataManager().getData4(urlString: url, parameters: postString1, headers: postString2, method: "POST", type: self.typeArray[self.segment.selectedSegmentIndex], completion: { (data) in
//                DispatchQueue.main.async {
//                    self.printResult(data as! String)
//                }
//            })
            break
        case 4:
            DataManager().getToken1(urlString: url, parameters: postString1, method: "POST", type: self.typeArray[self.segment.selectedSegmentIndex]) { (data) in
                DispatchQueue.main.async {
                    print("data = \(data)")
                    self.printResult(data as! String)
                }
            }

        case 5:
            DataManager().getToken4(urlString: url, parameters: postString1, method: "POST") {(data) in
                DispatchQueue.main.async {
                    print("data = \(data)")
                    self.printResult2("\(data)")
                }
            }
            
        case 6:
            DataManager().getToken6(urlString: url, parameters: postString1, method: "POST", completion: { (data) in
                DispatchQueue.main.async {
                    print("data = \(data)")
                    self.printResult2("\(data)")
                }
                
            })
        case 7:
            Alamofire.request(url, method: .post, parameters: postString6, encoding: JSONEncoding(options: []), headers: ["Content-Type" : "application/json"]).response(completionHandler: { (data) in
                DispatchQueue.main.async {
                    print("request = \(String(describing: data.request))")
                    print("response = \(String(describing: data.response))")
                    print("data = \(String(describing: data.data))")
                    
                    let result = try? JSONSerialization.jsonObject(with: data.data!, options: .mutableContainers)
                    
                    self.printResult2("\(String(describing: data.request))","\(String(describing: data.response))","\(result)")
                }
                
            })
            
        case 8:
            Alamofire.request(url, method: .post).authenticate(user: "\(userName)", password: "\(passWord)").response(completionHandler: { (data) in
                DispatchQueue.main.async {
                    print("request = \(String(describing: data.request))")
                    print("response = \(String(describing: data.response))")
                    print("data = \(String(describing: data.data))")
                    self.printResult2("\(String(describing: data.request))","\(String(describing: data.response))","\(String(describing: data.data))")
                }
            })
            
        case 9:
            
            DataManager().getData5(urlString: url, parameters: postString2, method: "POST", type: .json, completion: { (data) in
                DispatchQueue.main.async {
                    self.printResult(data as! String)
                }
            })
            
        case 10:
            DataManager().getData1(urlString: url, parameters: postString6, method: "POST", type: self.typeArray[self.segment.selectedSegmentIndex], completion: { (data) in
                self.printResult(data as! String)
            })
            
        default:
            break
        }
    }
}

