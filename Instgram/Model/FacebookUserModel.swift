//
//  FacebookUserModel.swift
//  Instgram
//
//  Created by Mahmoud Mohammed on 9/28/18.
//  Copyright © 2018 Mahmoud Mohammed. All rights reserved.
//

import Foundation

struct FacebookUserModel: Codable {
    var picture = Picture()
    var id = ""
    var email = ""
    var name = ""
    var name_format = ""
    var last_name = ""
    var short_name = ""
    var first_name = ""
}

struct Picture: Codable {
    var data = PhotoData()
}

struct PhotoData: Codable {
    var height = -1
    var width = -1
    var url = ""
    var is_silhouette = false
}

