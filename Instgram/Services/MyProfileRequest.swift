//
//  AuthService.swift
//  Instgram
//
//  Created by Mahmoud Mohammed on 9/28/18.
//  Copyright © 2018 Mahmoud Mohammed. All rights reserved.
//

import Foundation
import FacebookCore

struct MyProfileRequest: GraphRequestProtocol {
    struct Response: GraphResponseProtocol {
        var facebookUserData = FacebookUserModel()
        init(rawResponse: Any?) {
            // Decode JSON from rawResponse into other properties here.
            guard (rawResponse as? NSDictionary) != nil else { return }
            do {
                let rawdata = try JSONSerialization.data(withJSONObject: rawResponse as Any, options: .sortedKeys)
                let userData = try! JSONDecoder().decode(FacebookUserModel.self, from: rawdata)
                self.facebookUserData = userData
            } catch let err {
                debugPrint(err.localizedDescription)
            }
            
        }
        
    }
    
    var graphPath = "/me"
    var parameters: [String : Any]? = ["fields": "id, name, email, picture, first_name, last_name, middle_name, name_format, short_name"]
    //        var parameters: [String : Any]? = ["fields": "id, name, email, picture"]
    var accessToken = AccessToken.current
    var httpMethod: GraphRequestHTTPMethod = .GET
    var apiVersion: GraphAPIVersion = .defaultVersion
}
