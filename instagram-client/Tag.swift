//
//  File.swift
//  instagram-client
//
//  Created by kuzindmitry on 11.07.17.
//  Copyright © 2017 Dmitry Kuzin. All rights reserved.
//

import Foundation

class Tag {
    
    let media_count: Int
    let name: String
    
    init(response: [String:Any]) {
        media_count = response["media_count"] as! Int
        name = response["name"] as! String
    }
    
}
