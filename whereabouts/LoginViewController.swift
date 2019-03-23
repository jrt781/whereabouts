//
//  LoginViewController.swift
//  whereabouts
//
//  Created by Jake Tyler on 3/20/19.
//  Copyright © 2019 Jake Tyler. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
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
