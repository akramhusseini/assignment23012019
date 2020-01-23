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
    func reloadProductTableView()
}



class searchPresenterView  {
    //private let service: WAService
    private let service: searchService
    weak private var view : searchView?
    
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
        
        // first lets get token from key chain
        
        guard let token = KeychainWrapper.standard.string(forKey: "token") else {
            // failed to get token, lets exit
            print("error, there is no token stored")
            return
        }
        view?.displayLoader()
        service.searchProducts(searchTerm: searchTerm, token: token) { (products) in
            if let products = products {
                self.products = products
                self.view?.reloadProductTableView()
                
            } else {
                print("no products found")
                // clear db and reload
                self.products.removeAll()
                self.view?.reloadProductTableView()
            }

            self.view?.removeLoader()
           print("display search results!")
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
