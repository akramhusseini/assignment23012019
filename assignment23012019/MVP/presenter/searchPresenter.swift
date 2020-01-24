//
//  searchPresenter.swift
//  assignment23012019
//
//  Created by Akram Samir Husseini on 1/23/20.
//  Copyright © 2020 Akram Samir Husseini. All rights reserved.
//

import Foundation
import UIKit
import SwiftKeychainWrapper

//
//  loginPresenter.swift
//  assignment23012019
//
//  Created by Akram Samir Husseini on 1/23/20.
//  Copyright © 2020 Akram Samir Husseini. All rights reserved.


protocol searchView : UIViewController {
    func displayLoader()
    func removeLoader()
    func reloadProductTableView(hasData: Bool)
}



class searchPresenterView  {
    //private let service: WAService
    private let service: searchService
    weak private var view : searchView?
    
    var totalLines : Int?
    var pageLinks : [String] = []
    
    
    private var products : [product] = []
    
    init(_ service: searchService) {
        self.service = service
    }
    
    
    
    
    /**
     get Search AutoComplete Products and saves in array
     - Parameter: none
     - Returns: none
     */
    func SearchProducts(searchTerm: String) {
        
        page = 1
        nextPageLink = nil
        lastPageLoaded = nil
        
        // get token from key chain
        guard let token = KeychainWrapper.standard.string(forKey: "token") else {
            // failed to get token, lets exit
            print("error, there is no token stored")
            return
        }
        view?.displayLoader()
        service.searchProducts(searchTerm: searchTerm, token: token) { (products, summary) in
            if let products = products,
                let summary = summary,
                let TotalCountOfLines = summary["TotalCountOfLines"] as? Int,
                let links = summary["_links"] as? [[String:Any]]
//                ,let totalPages = summary["TotalCountOfPages"] as? Int
            {
                print(TotalCountOfLines)
                self.totalLines = TotalCountOfLines
                self.products = products
                let hasData = self.products.count > 0
                
                self.nextPageLink = nil
                for linkItem in links {
                    if let Rel = linkItem["Rel"] as? String,
                        Rel == "Next",
                        let link = linkItem["Href"] as? String {
                        self.nextPageLink = link
                        break
                    }
                }
                
              
                
                
                self.view?.reloadProductTableView(hasData: hasData)
                
            } else {
                print("no products found")
                // clear db and reload
                self.products.removeAll()
                self.view?.reloadProductTableView(hasData: false)
            }

            self.view?.removeLoader()
           print("display search results!")
        }
    }
    
   
    var nextPageLink : String?
    var lastPageLoaded : String?
    
    /**
     checks if a next page was found in the last API call
     - Parameter: none
     - Returns: none
     */
    func isThereANextPageToLoad() -> Bool {
        if nextPageLink != nil {
            return true
        } else {
            return false
        }
    }
    
    
    var page = 1
    /**
     loads next page if available
     - Parameter: none
     - Returns: none
     */
    func loadAdditionalPage() {
        
        
        
        
        
        
        // get next page URL if available, else exit
        guard let nextPageUrl = nextPageLink else { return }
        
        // check for any multithread issues
        
        if let lastPageLoaded = lastPageLoaded,
            nextPageUrl == lastPageLoaded {
            // this is a double page load, lets exit
            return
        } else {
            lastPageLoaded = nextPageUrl
            page = page + 1
            print("load next page : \(page)")
        }
           
        
        
        
        // get token from key chain, else exit
               guard let token = KeychainWrapper.standard.string(forKey: "token") else {
                   // failed to get token, lets exit
                   print("error, there is no token stored")
                   return
               }
        
//        view?.displayLoader()
        service.getNextPage(pageURL: nextPageUrl, method: "GET", token: token) { (products, summary) in
            self.nextPageLink = nil
            if let products = products,
            let summary = summary,
            let links = summary["_links"] as? [[String:Any]] {
                for product in products {
                    self.products.append(product)
                }
                let hasData = self.products.count > 0
                self.nextPageLink = nil
                for linkItem in links {
                    if let Rel = linkItem["Rel"] as? String,
                        Rel == "Next",
                        let link = linkItem["Href"] as? String {
                        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250), execute: {
                            // Put your code which should be executed with a delay here
                            self.nextPageLink = link
                        })
                        
                        break
                    }
                }
                self.view?.reloadProductTableView(hasData: hasData)
            }
            
//            self.view?.removeLoader()
            
        }
        
    }
    
    
    
    /**
     get tableview records from the count of products
     - Parameter none
     - Returns: none
     */
    
    func getProductCount() -> Int {
        return products.count
    }
    
    
    /**
     check if presenter View is not attached to controller
     - Parameter none
     - Returns: none
     */
   func getProductCell(tableView: UITableView, indexPath : IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCellId", for: indexPath) as! productTableViewCell
    cell.name.text = products[indexPath.row].name
    cell.productImage.getImage(using: products[indexPath.row].ImageUrl)
    

    return cell
    
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
    func attachView(_ view: searchView) {
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
