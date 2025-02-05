//
//  Location.swift
//  Dub Dub Circle
//
//  Created by Om Chachad on 1/31/25.
//

import MapKit
import Contacts

struct Location: Codable {
    var name: String
    var address: String
    
    var latitude: Double?
    var longitude: Double?
    
    var coordinate: CLLocationCoordinate2D? {
        if let latitude = latitude, let longitude = longitude {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        
        return nil
    }
}
