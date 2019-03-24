//
//  Util.swift
//  whereabouts
//
//  Created by Jake Tyler on 3/23/19.
//  Copyright © 2019 Jake Tyler. All rights reserved.
//

import Foundation

class Util {
    static func isKeyInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
}
