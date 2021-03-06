//
//  Switcher.swift
//  whereabouts
//
//  Created by Jake Tyler on 3/20/19.
//  Copyright © 2019 Jake Tyler. All rights reserved.
//

import Foundation

import UIKit

class Switcher {
    
    static func updateRootVC(){
        
        let isLoggedIn = UserDefaults.standard.bool(forKey: Constants.IS_LOGGED_IN)
        var rootVC : UIViewController?
        
        if(isLoggedIn == true){
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        } else {
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = rootVC
        
    }
    
}
