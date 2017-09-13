//
//  Artwork.swift
//  findme
//
//  Created by findme on 14/03/2017.
//  Copyright © 2017 esprit. All rights reserved.
//

import Foundation
import MapKit
class Artwork: NSObject, MKAnnotation{
    let title: String?
    let locationName: String
    let discipline:String
    let coordinate:CLLocationCoordinate2D
    let image:String
    
    
    
    init(title:String,locationName: String,discipline: String,coordinate:CLLocationCoordinate2D,image: String) {
        
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate=coordinate
        self.image=image
        
        super.init()
    }
    
    var subtitle: String?{
        return locationName
    }
    
    
}
