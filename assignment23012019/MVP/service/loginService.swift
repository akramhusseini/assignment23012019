//
//  loginService.swift
//  assignment23012019
//
//  Created by Akram Samir Husseini on 1/23/20.
//  Copyright © 2020 Akram Samir Husseini. All rights reserved.
//

import Foundation
import Alamofire


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
    
    func getAutoComplete(token: String, completion: @escaping ([String]?) -> Void) {
        Utility.getURLAndMethod(Rel: SearchAutoCompleteProductsRel) { (url, method) in
                           if let url = url, let method = method,
                               let httpMethod = method.httpMethodFromString(){
                               
                               
                               let header = ["Accept" : "application/json",
                                             "Authorization" : "Bearer \(token)"]
                               
                               Alamofire.request(url, method: httpMethod,parameters: nil, headers: header).validate().responseJSON { response in
                                if let dict = response.result.value as? [String:Any],
                                    let ProductNameList = dict["ProductNameList"] as? [[String:Any]]{
                                    
                                    var strings : [String] = []
                                    for item in ProductNameList {
                                        if let name = item["Name"] as? String {
                                            
                                            strings.append(name)
                                        }
                                    }
                                    completion(strings)
                                    
//                                   print(dict)
                                }
//                                print(response.result.value!)
                               }
                               
                           }
                           
                       }
    }
    
}




