//
//  ViewController.swift
//  interViewTest
//
//  Created by Eric Chen on 2017/6/21.
//  Copyright © 2017年 MasB1ue. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var titleLabel: UILabel!
    var nameTextField: UITextField!
    var passTextField: UITextField!
    var chickBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        setUI()
        nameTextField.text = "user01"
        passTextField.text = "1a2b3cd4"
    }
    
    private func initUI() {
        self.titleLabel = UILabel()
        self.titleLabel.text = "登入系統"
        self.titleLabel.textColor = UIColor.darkGray
        self.titleLabel.font = UIFont(name: "Helvetica", size: 40)
        self.titleLabel.textAlignment = NSTextAlignment.center
        self.titleLabel.adjustsFontSizeToFitWidth = true
        self.titleLabel.minimumScaleFactor = 0.5
        self.view.addSubview(self.titleLabel)
        
        self.nameTextField = UITextField()
        self.nameTextField.placeholder = "請輸入帳號"
        self.nameTextField.font = UIFont.systemFont(ofSize: 24)
        self.nameTextField.textAlignment = NSTextAlignment.left
        self.nameTextField.borderStyle = .roundedRect
        self.nameTextField.clearButtonMode = .whileEditing
        self.nameTextField.keyboardType = .default
        self.nameTextField.textColor = UIColor.black
        self.view.addSubview(self.nameTextField)
        
        self.passTextField = UITextField()
        self.passTextField.placeholder = "請輸入密碼"
        self.passTextField.font = UIFont.systemFont(ofSize: 24)
        self.passTextField.textAlignment = NSTextAlignment.left
        self.passTextField.borderStyle = .roundedRect
        self.passTextField.isSecureTextEntry = true
        self.passTextField.clearButtonMode = .whileEditing
        self.passTextField.keyboardType = .default
        self.passTextField.textColor = UIColor.black
        self.view.addSubview(self.passTextField)
        
        self.chickBtn = UIButton(type: .system)
        self.chickBtn.setTitle("login", for: .normal)
        self.chickBtn.addTarget(self, action: #selector(onBtnAction(_:)), for: .touchUpInside)
        self.view.addSubview(self.chickBtn)
    }
    
    private func setUI() {
        let gap: CGFloat = 20
        
        self.titleLabel.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 45)
        self.titleLabel.center = CGPoint(x: self.view.bounds.midX, y: self.titleLabel.frame.height / 2 + (self.navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.height + gap)
        
        self.nameTextField.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        self.nameTextField.center = CGPoint(x: self.view.bounds.midX, y: self.titleLabel.frame.maxY + gap + self.nameTextField.frame.height / 2)
        
        self.passTextField.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        self.passTextField.center = CGPoint(x: self.view.bounds.midX, y: self.nameTextField.frame.maxY + gap + self.passTextField.frame.height / 2)
        
        self.chickBtn.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        self.chickBtn.center = CGPoint(x: self.view.bounds.midX, y: self.passTextField.frame.maxY + gap + self.chickBtn.frame.height / 2)
    }
    
    //MARK: -selector
    
    func onBtnAction(_ sender: UIButton)  {
        
        if nameTextField.text! == "" || passTextField.text! == "" {
            //確認有無填寫
            let alertController = UIAlertController(title: "錯誤", message: "未填寫完全", preferredStyle: .alert)
            let alertAction1 = UIAlertAction(title: "確定", style: .default, handler: nil)
            alertController.addAction(alertAction1)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        let destinVC = SelectTableViewController()
        destinVC.userName = nameTextField.text!
        destinVC.passWord = passTextField.text!
        self.navigationController?.pushViewController(destinVC, animated: true)
        //將帳密傳至SelectTableViewController
        
    }
    
}

