//
//  SecondViewController.swift
//  whereabouts
//
//  Created by Jake Tyler on 3/12/19.
//  Copyright © 2019 Jake Tyler. All rights reserved.
//

import UIKit
import FirebaseAuth

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func logout(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        UserDefaults.standard.set(false, forKey: "status")
        Switcher.updateRootVC()
    }
    
}

