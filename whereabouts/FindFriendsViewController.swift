//
//  FindFriendsViewController.swift
//  whereabouts
//
//  Created by Jake Tyler on 3/21/19.
//  Copyright © 2019 Jake Tyler. All rights reserved.
//

import UIKit
import Firebase

class FindFriendsViewController: UIViewController {

    fileprivate var ref: DatabaseReference!
    fileprivate var storageRef: StorageReference!
    
    @IBOutlet weak var tableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Create references to Firebase
        self.storageRef = Storage.storage().reference()
        self.ref = Database.database().reference()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search usernames"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FindFriendsViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
    }
}
