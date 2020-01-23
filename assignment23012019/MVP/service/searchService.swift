//
//  searchService.swift
//  assignment23012019
//
//  Created by Akram Samir Husseini on 1/23/20.
//  Copyright © 2020 Akram Samir Husseini. All rights reserved.
//

import Foundation
import Alamofire


class searchService {
    
    
    init() {
        
     }

 
    
    func searchProducts(searchTerm: String, token: String, completion: @escaping ([product]?) -> Void) {
        Utility.getURLAndMethod(Rel: ProductsSearch) { (url, method) in
            if let url = url, let method = method,
                let httpMethod = method.httpMethodFromString(),
                let urlWithAddedSearchTerm = url.replacingOccurrences(of: "~SearchTerm", with:searchTerm).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
                
                let header = ["Accept" : "application/json",
                              "Authorization" : "Bearer \(token)"]
                
                
                Alamofire.request(urlWithAddedSearchTerm, method: httpMethod,parameters: nil, headers: header).validate().responseJSON { response in
                    if let dict = response.result.value as? [String:Any],
                        let productListDict = dict["Products"] as? [[String:Any]] {
                        
                        //                                    completion(strings)
                        let productList = productListDict.compactMap { dic in return product(jsonData: dic) }
                        completion(productList)
                        //                                   print(dict)
                    } else {
                        print("no products found")
                        completion(nil)
                    }
                    
                }
                
            }
            
        }
    }
    
}




