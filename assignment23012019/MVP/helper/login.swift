//
//  login.swift
//  assignment23012019
//
//  Created by Akram Samir Husseini on 1/23/20.
//  Copyright © 2020 Akram Samir Husseini. All rights reserved.
//

import Foundation
import Alamofire

open class loginManager {
    
    
    
    
    /**
     this is a utility function that will login the user and return the token via closure
     - Parameter: username, password
     - Returns: via completion handler, will return the token
     */
    static func login(username: String,password: String,completion: @escaping (String?) -> Void ) {
        Utility.getURLAndMethod(Rel: token) { (url, method) in
            if
                let url = url, let method = method,
                let httpMethod = method.httpMethodFromString() {
                
                

                // setup parameters
                let paramater: [String : Any] = ["grant_type": "password",
                                                 "client_id": "mobile",
                                                 "client_secret": "",
                                                 "username" : username,
                                                 "password" : password,
                                                 "scope" : ""
                ]
                
               
                
                Alamofire.request(url, method: httpMethod, parameters: paramater, headers: nil).responseJSON { (response) in
                    print(response)
                    if let dict = response.result.value as? [String:Any],
                        let accessToken = dict["access_token"] as? String{
                        completion(accessToken)
                        
                        
                    } else {
                        completion(nil)
                        
                    }
                }
                
            }
            
            
            
            
            
            
            
        }
    }
    
    
    
    
}


