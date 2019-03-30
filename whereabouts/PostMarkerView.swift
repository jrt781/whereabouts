//
//  PostMarkerView.swift
//  whereabouts
//
//  Created by Jake Tyler on 3/29/19.
//  Copyright © 2019 Jake Tyler. All rights reserved.
//

import Foundation
import MapKit

class PostMarkerView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            // 1
            guard let post = newValue as? Post else { return }
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            // 2
//            markerTintColor = artwork.markerTintColor
//            glyphText = String(artwork.discipline.first!)
//            glyphText = "P"
            glyphImage = UIImage(named: "lock.png")
        }
    }
}
