//
//  productModule.swift
//  assignment23012019
//
//  Created by Akram Samir Husseini on 1/23/20.
//  Copyright © 2020 Akram Samir Husseini. All rights reserved.
//

import Foundation


class product {
    var name: String
    var ImageUrl: String
    var DefaultRateFullText: String
    var ProductCode: String
    
    init(jsonData: [String:Any]) {
        
        print("jsdonData: \(jsonData)")
        
        if let name = jsonData["Name"] as? String {
            self.name = name
        } else {
            self.name = ""
        }
        
        if let ImageUrl = jsonData["ImageUrl"] as? String {
            self.ImageUrl = ImageUrl
        } else {
            self.ImageUrl = ""
        }
        
        if let DefaultRateFullText = jsonData["DefaultRateFullText"] as? String {
            self.DefaultRateFullText = DefaultRateFullText
        } else {
            self.DefaultRateFullText = ""
        }
        
        if let ProductCode = jsonData["ProductCode"] as? String {
            self.ProductCode = ProductCode
        } else {
            self.ProductCode = ""
        }
        
    }
    
}
