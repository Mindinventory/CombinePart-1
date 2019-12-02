//
//  FormVC.swift
//  CombineDemoWithUIKit
//
//  Created by mac-00015 on 29/11/19.
//  Copyright © 2019 mac-00015. All rights reserved.
//

import UIKit
import Combine

class FormVC: UIViewController {
    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var lblUsernameMessage: UILabel!
    @IBOutlet weak var lblPasswordMessage: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!
    
    var usernameSubsciber: AnyCancellable?
    var passwordSubsciber: AnyCancellable?
    
    private var cancellableSet: Set<AnyCancellable> = []
    private var formViewModel = FormViewModel()
    
    override func viewDidLoad() {
        
        super.viewDidLoad() 
        self.initialization()
    }
}

// MARK:- Initialization
// MARK:-
extension FormVC {
    
    fileprivate func initialization() {
        
        self.setupTextFields()
        
        let username = formViewModel.usernameMessagePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] (str) in
                
                guard let `self` = self else {
                    return
                }
                
                self.lblUsernameMessage.text = str
                if str != "" {
                    self.txtUsername.addRightView(txtField: self.txtUsername, str: "")
                } else {
                    self.txtUsername.addRightView(txtField: self.txtUsername, str: "👍🏻")
                }
        }
        usernameSubsciber = AnyCancellable(username)
        
        let password = formViewModel.passwordMessagePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] (str) in
                
                guard let `self` = self else {
                    return
                }
                
                self.lblPasswordMessage.text = str
                if str != "" {
                    self.txtPassword.addRightView(txtField: self.txtPassword, str: "")
                    self.txtConfirmPassword.addRightView(txtField: self.txtConfirmPassword, str: "")
                } else {
                    self.txtPassword.addRightView(txtField: self.txtPassword, str: "👍🏻")
                    self.txtConfirmPassword.addRightView(txtField: self.txtConfirmPassword, str: "👍🏻")
                }
        }
        passwordSubsciber = AnyCancellable(password)
        
        formViewModel.readyToSubmit
            .map { $0 != nil}
            .receive(on: RunLoop.main)
            .sink(receiveValue: { (isEnable) in
                if isEnable {
                    self.btnSubmit.backgroundColor = .systemGreen
                } else {
                    self.btnSubmit.backgroundColor = .red
                }
                self.btnSubmit.isEnabled = isEnable
            })
            .store(in: &cancellableSet)
    }
    
    fileprivate func setupTextFields() {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let `self` = self else {
                return
            }
            
            self.txtUsername.layer.cornerRadius = 10
            self.txtUsername.setLeftPaddingPoints(10)
            self.txtUsername.setRightPaddingPoints(10)
            self.txtUsername.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
            self.txtPassword.layer.cornerRadius = 10
            self.txtPassword.setLeftPaddingPoints(10)
            self.txtPassword.setRightPaddingPoints(10)
            self.txtPassword.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
            self.txtConfirmPassword.layer.cornerRadius = 10
            self.txtConfirmPassword.setLeftPaddingPoints(10)
            self.txtConfirmPassword.setRightPaddingPoints(10)
            self.txtConfirmPassword.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
            self.btnSubmit.layer.cornerRadius = self.btnSubmit.frame.height / 2
        }
    }
}

// MARK:- Action Events
// MARK:-
extension FormVC {
    
    @IBAction func updateUserName(_ sender: UITextField) {
        formViewModel.username = sender.text ?? ""
    }
    
    @IBAction func updatePassword(_ sender: UITextField) {
        formViewModel.password = sender.text ?? ""
    }
    
    @IBAction func updateConfirmPassword(_ sender: UITextField) {
        formViewModel.confirmPassword = sender.text ?? ""
    }
    
    @IBAction func btnSubmitClicked(_ sender: UIButton) {
        
        
    }
}
