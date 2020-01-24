//
//  ViewController.swift
//  assignment23012019
//
//  Created by Akram Samir Husseini on 1/23/20.
//  Copyright © 2020 Akram Samir Husseini. All rights reserved.
//

import UIKit
import Alamofire

class loginViewController: UIViewController {
    
    
    @IBOutlet weak var loginWithTouchiDBtn: UIButton!
    
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    let presenter = loginPresenterView(loginService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.attachView(self)
        
       
            
            
        }
    
    override func viewWillAppear(_ animated: Bool) {
        if !presenter.isViewAttached() {
            presenter.attachView(self)
        }
        

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        presenter.detachView()
    }
    
    @IBAction func login(_ sender: Any) {
        
        presenter.login(username: userName, password: password)
        
    }
    
    
    @IBAction func loginWithTouchId(_ sender: Any) {
        presenter.loginWithTouchId()
    }
    
    
    }

// MARK: - LoginView presenter Protocol


extension loginViewController : loginView {
    func loginSuccess() {
        print("login success!")
    }
    
    
}


// MARK: - Loader extension
extension loginViewController {
    
    /**
     this function displays the loader while the API is loading
     - Parameter none
     - Returns: none
     */
    func displayLoader() {
        self.showSpinner(onView: self.view)
    }
    
    
    /**
     this function hides the loader when the API is done loading
     - Parameter none
     - Returns: none
     */
    func removeLoader() {
        self.removeSpinner()
    }
}


