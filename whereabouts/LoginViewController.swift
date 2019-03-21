//
//  LoginViewController.swift
//  whereabouts
//
//  Created by Jake Tyler on 3/20/19.
//  Copyright © 2019 Jake Tyler. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
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
            
            print("\(user?.user.email ?? "User") logged in")
            UserDefaults.standard.set(true, forKey: "status")
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
