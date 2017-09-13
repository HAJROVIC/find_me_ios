//
//  SharedPref.swift
//  findme
//
//  Created by findme on 13/03/2017.
//  Copyright © 2017 esprit. All rights reserved.
//
import Foundation
class SharedPref{
    
    
    
    static var sharedpref  = SharedPref ()
    var prefs:UserDefaults = UserDefaults.standard
    
    
    private init() {}
    
    var id : Int!
    var fullName : String!
    var email : String!
    var picture : String!
    var password : String!
    var phone : Int!
    var position : String!
    var isLoggedin : Int!
    var circle_id : Int!
    var circle_code : String!
    var circle_index :Int!

    func setSharedprefs (email:String,id:Int,fullName : String , picture : String ,password : String,phone : Int,    position: String, isLogged:Int){
        
        prefs.set(email, forKey: "email")
        prefs.set(id, forKey: "id")
        prefs.set(fullName, forKey: "fullname")
        prefs.set(picture, forKey: "picture")
        prefs.set(password, forKey: "password")
        prefs.set(phone, forKey: "phone")
        prefs.set(position, forKey: "position")
        prefs.set(isLogged, forKey: "ISLOGGEDIN")
        
        prefs.synchronize()
        
        
        
    }
    func setPosition (position: String){
        
        prefs.set(position, forKey: "position")
        prefs.synchronize()
        
    }

    func setCircleSharedPref(id:Int,code:String)
    {
        
        prefs.set(id, forKey: "circle_id")
        prefs.set(code, forKey: "circle_code")
        prefs.synchronize()
        
    }
    func setCircleIndex(index:Int)
    {
        
        prefs.set(index, forKey: "circle_index")
        prefs.synchronize()
        
    }

    
}
