//
//  SignUpViewController.swift
//  whereabouts
//
//  Created by Jake Tyler on 3/20/19.
//  Copyright © 2019 Jake Tyler. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func signUp(_ sender: Any) {
        guard let username = usernameTextField.text, let password = passwordTextField.text, let confirm = confirmTextField.text else {
            return
        }
        
        if username.contains("@") {
            let alert = UIAlertController(title: "Signup Didn't Work!", message: "Username cannot contain @", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
            return;
        }
        
        let email = username + "@whereabouts.com"
        
        if password != confirm {
            let alert = UIAlertController(title: "Passwords do not match", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
            return;
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            guard let authResult = authResult, error == nil else {
                let message = error!.localizedDescription
                let replaced = message.replacingOccurrences(of: "email address", with: "username")
                let alert = UIAlertController(title: "Register Failed", message: replaced, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                self.present(alert, animated: true, completion: nil)
                return
            }
            print("\(authResult.user.email!) created")
            UserDefaults.standard.set(true, forKey: "status")
            Switcher.updateRootVC()
        }
    }
    
    @IBAction func backToLogIn(_ sender: Any) {
        self.dismiss(animated: true) {
            
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
