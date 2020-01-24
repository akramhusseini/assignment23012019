//
//  loginService.swift
//  assignment23012019
//
//  Created by Akram Samir Husseini on 1/23/20.
//  Copyright © 2020 Akram Samir Husseini. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift
import Realm


class loginService {
    
    ////
    init() {
        
     }

    func loginAndGetToken(completion: @escaping (String?) -> Void ) {
        loginManager.login(username: "testak@mailinator.com", password: "terokkar") { (token) in
            if let token = token {
                completion(token)
                
               
                
                
            } else {
                completion(nil)
            }
            
            
            
        }
        
    }
    
    
    
    func checkAutoCompleteIsFilled () -> Bool {
        
        
        do {
            let realm = try Realm()
            let items = realm.objects(autoCompleteTable.self)
            print(items.count)
            if items.count > 0 {
                return true
            } else {
                return false
            }


        } catch let error as NSError {
            print(error.localizedDescription)
            return true
        }
        
        
    }
    
    
    func getAutoComplete(token: String, completion: @escaping (Bool) -> Void) {
        
        // first check if we have data in realm or not
        
        if checkAutoCompleteIsFilled() {
            completion(true)
            return
        }
        
        
        
        Utility.getURLAndMethod(Rel: SearchAutoCompleteProductsRel) { (url, method) in
                           if let url = url, let method = method,
                               let httpMethod = method.httpMethodFromString(){
                               
                               
                               let header = ["Accept" : "application/json",
                                             "Authorization" : "Bearer \(token)"]
                               
                               Alamofire.request(url, method: httpMethod,parameters: nil, headers: header).validate().responseJSON { response in
                                if let dict = response.result.value as? [String:Any],
                                    let ProductNameList = dict["ProductNameList"] as? [[String:Any]]{
                                    
//                                    var strings : [String] = []
                                    for item in ProductNameList {
                                        if let name = item["Name"] as? String {
                                            do {
//                                            strings.append(name)
                                            let realm = try Realm()
                                                try realm.write {
                                                    let newAutoCompleteItem = autoCompleteTable()
                                                    newAutoCompleteItem.name = name
                                                    
                                                    realm.add(newAutoCompleteItem)
                                                }
                                            
                                            } catch let error as NSError {
                                                print(error.localizedDescription)
                                            }
                                        }
                                    }
                                    
                                    completion(true)
                                    
//                                   print(dict)
                                } else {
                                    completion(false)
                                }
//                                print(response.result.value!)
                               }
                               
                           }
                           
                       }
    }
    
}




