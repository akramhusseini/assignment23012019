//
//  loginPresenter.swift
//  assignment23012019
//
//  Created by Akram Samir Husseini on 1/23/20.
//  Copyright © 2020 Akram Samir Husseini. All rights reserved.
//

import Foundation
import UIKit
import SwiftKeychainWrapper
import LocalAuthentication

var autoCompleteArray : [String] = []

protocol loginView : UIViewController {
    
    func loginSuccess()
    func displayLoader()
    func removeLoader()
    
}



class loginPresenterView  {
    //private let service: WAService
    private let service: loginService
    weak private var view : loginView?
    
    
    init(_ service: loginService) {
        self.service = service
    }
    
    /**
     calls the login function from the service and saved token in keychain
     - Parameter: none
     - Returns: none
     */
    func login() {
        view?.displayLoader()
        service.loginAndGetToken { (token) in
            if let token = token {
                print(token)
                //                self.view?.removeLoader()
                
                let saveSuccessful: Bool = KeychainWrapper.standard.set(token, forKey: "token")
                if saveSuccessful{
                    print("token saved success")
                }
                
                self.getSearchAutoCompleteProducts()
                
                
                
            } else {
                self.loginFailed()
                self.view?.removeLoader()
            }
        }
    }
    
    /**
     get Search AutoComplete Products and saves in array
     - Parameter: none
     - Returns: none
     */
    func getSearchAutoCompleteProducts() {
        
        // first lets get token from key chain
        
        guard let token = checkToken() else {
            // failed to get token, lets exit
            print("error, there is no token stored")
            return
        }
        //        view?.displayLoader()
        service.getAutoComplete(token: token) { (completed) in
            DispatchQueue.main.async {
                self.view?.removeLoader()
            }
            print(completed)
            
//            if let names = names {
//                autoCompleteArray = names
//            }
            //            print(result as Any)
            
            self.gotoSearch()
        }
    }
    
    /**
     sends  user to search
     - Parameter none
     - Returns: none
     */
    func gotoSearch() {
        view?.removeLoader()
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let searchVC = mainStoryboard.instantiateViewController(withIdentifier: "searchViewController") as! searchViewController
        self.view?.navigationController?.pushViewController(searchVC, animated: true)
        self.view?.loginSuccess()
    }
    
    func checkToken()-> String? {
        if let token = KeychainWrapper.standard.string(forKey: "token") {
            return token
        } else {
            return nil
        }
    }
    
    
    /**
     checks touchID
     - Parameter none
     - Returns: none
     */
    
    func loginWithTouchId() {
        
        guard let token = checkToken() else {
            // failed to get token, lets exit
            print("error, there is no token stored")
            let ac = UIAlertController(title: "Login first, token not recognized!", message: "Sorry!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.view?.present(ac, animated: true)
            return
        }
        
        
        
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [unowned self] success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        print("success")
                        
                        self.getSearchAutoCompleteProducts()
                        
                        
                        
                    } else {
                        let ac = UIAlertController(title: "Authentication failed", message: "Sorry!", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self.view?.present(ac, animated: true)
                    }
                }
            }
        } else {
            let ac = UIAlertController(title: "Touch ID not available", message: "Your device is not configured for Touch ID.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            view?.present(ac, animated: true)
        }
    }
    
    
    
    /**
     report login failed
     - Parameter none
     - Returns: none
     */
    func loginFailed() {
        print("login failed")
    }
    
    
    /**
     check if presenter View is not attached to controller
     - Parameter none
     - Returns: none
     */
    
    func isViewAttached()->Bool {
        if view == nil {
            return false
        } else {
            return true
        }
    }
    
    
    /**
     attach presenter to controller
     - Parameter none
     - Returns: none
     */
    func attachView(_ view: loginView) {
        self.view = view
    }
    
    
    /**
     detach presenter from controller
     - Parameter none
     - Returns: none
     */
    func detachView() {
        self.view = nil
    }
    
    
}
