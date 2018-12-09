//
//  User.swift
//  Instgram
//
//  Created by ASUGARDS on 11/13/18.
//  Copyright © 2018 Mahmoud Mohammed. All rights reserved.
//

import Foundation

struct User {
    let uid: String
    let username: String
    let profileImageUrl: String
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    }
}
