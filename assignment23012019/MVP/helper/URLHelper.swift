//
//  URLHelper.swift
//  assignment23012019
//
//  Created by Akram Samir Husseini on 1/23/20.
//  Copyright © 2020 Akram Samir Husseini. All rights reserved.
//

import Foundation
import Alamofire

open class Utility {
    
    
    
    /**
    this is a utility function that will return the corresponding URL via the Rel string from the mainURL.
    - Parameter: Rel string, represents the URL we are seeking
    - Returns: via completion handler, will return a URL String if found.
    */
    
   static func getURLAndMethod( Rel: String,completion: @escaping (String?, String?) -> Void) {
    
    let url = MainUrl

        
        
    
    Alamofire.request(url, method: .get,parameters: nil).validate().responseJSON { response in
        
        // lets do some checks for the responce
        if
            let statusCode = response.response?.statusCode,                         // can we read status code? if yes proceed
            200 ..< 300 ~= statusCode ,                                             // is status code within range 200 to 300? if so proceed
            let body = response.result.value as? [String:Any],                      // can we read main responce body? if yes proceed
            let links = body["_links"] as? [[String:Any]],                          // can we get links array? if so proceed
            let linkrecord = links.first(where: {$0["Rel"] as? String == Rel}),     // check link array and return a link record if found
            let returnURL = linkrecord["Href"] as? String,
            let method = linkrecord["Method"] as? String {                         // get the link
            //success, got the link, return with completion
//            print("got the link : \(returnURL)")
            completion(returnURL, method)
            
            
        } else {
            
            // we failed one of the checks. exit with fail
//            print("error no status code")
            completion(nil, nil)
        }
        
        
        
    }
    
    
    
    }
    
}



extension String {
    
    func httpMethodFromString()-> HTTPMethod? {
        switch self {
        case "POST":
            return .post
        case "GET":
            return .get
            
        default:
            return nil
        }
    }
    
}
