//
//  LocationManager.swift
//  whereabouts
//
//  Created by Jake Tyler on 3/30/19.
//  Copyright © 2019 Jake Tyler. All rights reserved.
//

import Foundation
import MapKit

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    
    var userLocation: CLLocation?
    
    private var observers = [LocationObserver]()
    
    private override init() {}
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let definiteUserLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        self.userLocation = definiteUserLocation
        print("location = \(locValue.latitude) \(locValue.longitude)")
        for observer in observers {
            observer.onLocationUpdate(userLocation: definiteUserLocation)
        }
    }
    
    func addLocationObserver(observer: LocationObserver) {
        observers.append(observer)
    }
}
