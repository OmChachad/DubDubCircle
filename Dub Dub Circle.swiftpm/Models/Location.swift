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

extension Location {
    init?(mapItem: MKMapItem) {
        guard let name = mapItem.name else { return nil }
        
        let coord = mapItem.placemark.coordinate
        self.address = CNPostalAddressFormatter().string(from: mapItem.placemark.postalAddress ?? CNMutablePostalAddress()).split(separator: "\n").joined(separator: ", ")
        self.name = name
        self.latitude = coord.latitude
        self.longitude = coord.longitude
    }
}
