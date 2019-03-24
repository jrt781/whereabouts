//
//  LoginViewController.swift
//  whereabouts
//
//  Created by Jake Tyler on 3/20/19.
//  Copyright © 2019 Jake Tyler. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class LoginViewController: UIViewController, UITextFieldDelegate {

    fileprivate var ref: DatabaseReference!
    fileprivate var storageRef: StorageReference!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        // Create references to Firebase
        self.storageRef = Storage.storage().reference()
        self.ref = Database.database().reference()
        
        usernameTextField.delegate = self
        usernameTextField.tag = 0
        passwordTextField.delegate = self
        passwordTextField.tag = 1
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
            
            if textField == passwordTextField {
                btnActionLogIn(passwordTextField)
            }
        }
        // Do not add a line break
        return false
    }
    
    @IBAction func btnActionLogIn(_ sender: Any) {
        guard let username = usernameTextField.text, let password = passwordTextField.text else {
            return
        }
        
        let email = username + "@whereabouts.com"

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
            guard error == nil else {
                let message = error!.localizedDescription
                let replaced = message.replacingOccurrences(of: "email address", with: "username")
                let alert = UIAlertController(title: "Login Failed", message: replaced, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                self?.present(alert, animated: true, completion: nil)
                return
            }
            
//            if let firebaseUser = user?.user {
//                let uid = firebaseUser.uid
//            }
        
            guard let strongSelf = self else {
                return
            }
            
            UserDefaults.standard.setValue([String](), forKey: Constants.FRIEND_USERNAMES)
            
            strongSelf.ref.child("users").child(username).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                guard let uid = value?["id"] else {
                    Auth.auth().currentUser?.delete { error in
                        if error != nil {
                            let alert = UIAlertController(title: "Something went wrong!", message: "Please try again.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                                NSLog("The \"OK\" alert occured.")
                            }))
                            strongSelf.present(alert, animated: true, completion: nil)
                        } else {
                            let alert = UIAlertController(title: "User not found", message: "This username doesn't exist.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                                NSLog("The \"OK\" alert occured.")
                            }))
                            strongSelf.present(alert, animated: true, completion: nil)
                        }
                    }
                    
                    return
                }
                
                print("Found user:", uid)
                
                let friendUsernamesFirebase = value?["friends"] as? NSDictionary
                var friendUsernames = [String]()
                if let friendUsernamesFirebase = friendUsernamesFirebase {
                    for (key, _) in friendUsernamesFirebase {
                        friendUsernames.append(key as! String)
                    }
                }
                
                print("friends are", friendUsernames)
                UserDefaults.standard.set(friendUsernames, forKey: Constants.FRIEND_USERNAMES)
            }) { (error) in
                print(error.localizedDescription)
            }

            print("\(user?.user.email ?? "User") logged in")
            UserDefaults.standard.set(true, forKey: Constants.IS_LOGGED_IN)
            UserDefaults.standard.set(username, forKey: Constants.CURRENT_USERNAME)
            Switcher.updateRootVC()
        }
        
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
