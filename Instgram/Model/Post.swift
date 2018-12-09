//
//  Post.swift
//  Instgram
//
//  Created by ASUGARDS on 11/7/18.
//  Copyright © 2018 Mahmoud Mohammed. All rights reserved.
//

import Foundation

struct Post {
    let user: User
    let imageUrl: String
    let caption: String
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""
    }
}
