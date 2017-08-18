//
//  Authorization.swift
//  instagram-client
//
//  Created by kuzindmitry on 01.08.17.
//  Copyright © 2017 Dmitry Kuzin. All rights reserved.
//

import Foundation
import UIKit

protocol AuthorizationCommand {
    func execute()
}

class Login: AuthorizationCommand {
    func execute() {
        UIApplication.topViewController?.present(UIStoryboard(name: "Main", bundle:nil).instantiateInitialViewController()!, animated: true, completion: nil)
    }
}

class Logout: AuthorizationCommand {
    func execute() {
        Credential.token = nil
        UIApplication.topViewController?.present(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Authorization"), animated: true, completion: nil)
    }
}

class AuthorizationService {
    private let loginCommand: AuthorizationCommand
    private let logoutCommand: AuthorizationCommand
    
    init() {
        loginCommand = Login()
        logoutCommand = Logout()
    }
    
    func login() {
        loginCommand.execute()
    }
    
    func logout() {
        logoutCommand.execute()
    }
}
