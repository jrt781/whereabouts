//
//  LocationObserver.swift
//  whereabouts
//
//  Created by Jake Tyler on 3/30/19.
//  Copyright © 2019 Jake Tyler. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationObserver {
    func onLocationUpdate(userLocation: CLLocation)
}
