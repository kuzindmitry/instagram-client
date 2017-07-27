//
//  UserPhoto.swift
//  instagram-client
//
//  Created by kuzindmitry on 27.07.17.
//  Copyright © 2017 Dmitry Kuzin. All rights reserved.
//

import Foundation

protocol UserPhoto {
    var username: String { get }
    var pictureUrl: String { get }
}

class SenderPhoto: UserPhoto {
    
    private let owner: User
    
    init(owner: User) {
        self.owner = owner
    }
    
    var username: String {
        return owner.username
    }
    
    var pictureUrl: String {
        return owner.profile_picture
    }
    
}
