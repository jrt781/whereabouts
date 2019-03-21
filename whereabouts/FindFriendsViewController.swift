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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Create references to Firebase
        self.storageRef = Storage.storage().reference()
        self.ref = Database.database().reference()
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
