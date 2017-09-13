//
//  Circle.swift
//  findme
//
//  Created by findme on 14/03/2017.
//  Copyright © 2017 esprit. All rights reserved.
//

import Foundation
class Circle:NSObject{
    var id : String!
    var name : String!
    var code : String!
    var desc : String!
    
    
    override init() {
        
    }
    
    init(dic : [String : Any]) {
        id = dic["id"] as! String
        name = dic["title"] as! String
        code = dic["code"] as! String
        desc = dic["description"] as! String
        
    }
    
}
