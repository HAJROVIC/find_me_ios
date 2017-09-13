//
//  User.swift
//  findme
//
//  Created by ESPRIT on 04/04/2017.
//  Copyright © 2017 esprit. All rights reserved.
//

import Foundation
class Friend:NSObject{
    var id : String!
    var name : String!
    var picture : String!
    var email : String!
    var position : String!
    
    override init() {
        
    }
    
    init(dic : [String : Any]) {
        id = dic["id"] as! String
        name = dic["name"] as! String
        picture = dic["photo"] as! String
        email = dic["email"] as! String
        position = dic["position"] as! String
    }
    
}
