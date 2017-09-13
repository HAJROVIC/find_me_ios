//
//  News.swift
//  findme
//
//  Created by ESPRIT on 07/03/2017.
//  Copyright © 2017 esprit. All rights reserved.
//

import UIKit
class News:NSObject{
    var id : String!
    var name : String!
    var picture : String!
    var url : String!
    var desc : String!
    var date : String!
    
    override init() {
        
    }
    
    init(dic : [String : Any]) {
        id = dic["id"] as! String
        name = dic["user_name"] as! String
        picture = dic["photo"] as! String
        desc = dic["content"] as! String
        url = dic["url"] as! String
        date = dic["when"] as! String
        
    }
    
}


