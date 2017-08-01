//
//  ResultViewController.swift
//  interViewTest2
//
//  Created by Eric Chen on 2017/6/28.
//  Copyright © 2017年 MasB1ue. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    //印出結果
    var resultTextView: UITextView!
    
    var str: String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resultTextView = UITextView(frame: self.view.frame)
        self.resultTextView.font = UIFont.systemFont(ofSize: 20)
        self.resultTextView.textAlignment = NSTextAlignment.left
        self.resultTextView.textColor = UIColor.black
        self.resultTextView.text = str
        self.resultTextView.backgroundColor = UIColor.white
        self.resultTextView.isEditable = false
        self.view.addSubview(self.resultTextView)
 
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
