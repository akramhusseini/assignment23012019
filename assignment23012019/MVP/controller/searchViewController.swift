//
//  searchViewController.swift
//  assignment23012019
//
//  Created by Akram Samir Husseini on 1/23/20.
//  Copyright © 2020 Akram Samir Husseini. All rights reserved.
//

import UIKit

class searchViewController: UIViewController, UITextFieldDelegate {

    let presenter = searchPresenterView(searchService())
    
    @IBOutlet weak var search: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.attachView(self)
        tableView.dataSource = self
        tableView.delegate = self
        search.delegate = self
        search.addTarget(self, action: #selector(enterPressed), for: .editingDidEndOnExit)
//        if let imageWithColor = searchButton.imageView?.image?.imageWithColor(color1: UIColor.white) {
//            searchButton.imageView?.image = imageWithColor
//        }
        searchButton.imageView?.contentMode = .scaleAspectFit
        tableView.rowHeight = 150
     
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if !presenter.isViewAttached() {
            presenter.attachView(self)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        presenter.detachView()
    }
    
    
    
    @IBAction func search(_ sender: Any) {
        performSearch()
    }
    
    @objc func enterPressed() {
        performSearch()
        
        
    }
    
    func performSearch() {
        print("searching products")
        
        if let searchTerm = search.text {
            presenter.SearchProducts(searchTerm: searchTerm)
        }
        
    }
    
    
}




  // MARK: - tableView Delegates

extension searchViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getProductCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return presenter.getProductCell(tableView: tableView, indexPath: indexPath)
    }
    
    
}



// MARK: - searchPresenter extension

extension searchViewController : searchView {
    
    func reloadProductTableView() {
        tableView.reloadData()
    }
    
 
    
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
