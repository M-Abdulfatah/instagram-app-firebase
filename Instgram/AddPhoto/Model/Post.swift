//
//  Post.swift
//  Instgram
//
//  Created by ASUGARDS on 11/7/18.
//  Copyright © 2018 Mahmoud Mohammed. All rights reserved.
//

import Foundation

struct Post {
    let imageUrl: String
    
    init(dictionary: [String: Any]) {
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
    }
}
