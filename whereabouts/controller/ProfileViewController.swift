//
//  ProfileViewController.swift
//  whereabouts
//
//  Created by Jake Tyler on 3/21/19.
//  Copyright © 2019 Jake Tyler. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ProfileViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    fileprivate var ref: DatabaseReference!

    @IBOutlet weak var findFriendsTextField: UITextField!
    @IBOutlet weak var friendsTableView: UITableView!
    
    var friendUsernames : [String] = []
    
    func getFriendsData() {
        friendUsernames = UserDefaults.standard.array(forKey: Constants.FRIEND_USERNAMES) as? [String] ?? [String]()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        getFriendsData()
        friendsTableView.delegate = self
        friendsTableView.dataSource = self
        friendsTableView.reloadData()
        print("(ProfileViewController) The friends are", friendUsernames)

        // Create references to Firebase
        self.ref = Database.database().reference()

        findFriendsTextField.delegate = self
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        UserDefaults.standard.set(false, forKey: Constants.IS_LOGGED_IN)
        Switcher.updateRootVC()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        print("\"Go\" has been pressed with", textField.text ?? "nothing", "in the text field")
        
        guard let currentUsername = UserDefaults.standard.string(forKey: Constants.CURRENT_USERNAME) else {
            // Error: user is not logged in somehow?? Just log them out
            UserDefaults.standard.set(false, forKey: Constants.IS_LOGGED_IN)
            Switcher.updateRootVC()
            return false;
        }
        
        let username = textField.text ?? ""
        if username.isEmpty {
            let alert = UIAlertController(title: "Can't Find Friend", message: "Please enter a username to search for.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        if username == currentUsername {
            let alert = UIAlertController(title: "Nice try", message: "You can't be friends with yourself!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        if friendUsernames.contains(username) {
            let alert = UIAlertController(title: "Nice try", message: "You're already friends with " + username + ".", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        self.ref.child("users").child(username).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            guard let uid = value?["id"] else {
                let alert = UIAlertController(title: "User not found", message: "This username doesn't exist.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            print("Found user:", uid)
            
            // Set each other as friends
            self.ref.child("users").child(snapshot.key).child("friends").child(currentUsername).setValue(true)
            self.ref.child("users").child(currentUsername).child("friends").child(snapshot.key).setValue(true)

            // Add friend to list in app's memory
            var friendUsernames = UserDefaults.standard.array(forKey: Constants.FRIEND_USERNAMES) as! [String]
            friendUsernames.append(snapshot.key)
            UserDefaults.standard.set(friendUsernames, forKey: Constants.FRIEND_USERNAMES)
            
            self.getFriendsData()
            self.friendsTableView.reloadData()
            textField.text = ""
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        // Remove keyboard.
        textField.resignFirstResponder()
        
        // Do not add a line break
        return false
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendUsernames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = friendsTableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        
        cell.textLabel?.text = friendUsernames[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("friend", friendUsernames[indexPath.row], "selected")
    }

}
