//
//  Credential.swift
//  instagram-client
//
//  Created by kuzindmitry on 11.07.17.
//  Copyright © 2017 Dmitry Kuzin. All rights reserved.
//

import Foundation

class Credential {
    
    static var userIsAuthorized: Bool {
        if (token != nil) {
            return true
        }
        return false
    }
    
    static var token: String? {
        get {
            return UserDefaults.standard.value(forKey: "token") as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "token")
        }
    }
}
