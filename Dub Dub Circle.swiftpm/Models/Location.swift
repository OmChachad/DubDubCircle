//
//  Location.swift
//  Dub Dub Circle
//
//  Created by Om Chachad on 1/31/25.
//

import MapKit

struct Location: Codable {
    var name: String
    var latitude: Double
    var longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
