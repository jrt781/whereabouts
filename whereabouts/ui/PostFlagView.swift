//
//  PostFlagView.swift
//  whereabouts
//
//  Created by Jake Tyler on 3/29/19.
//  Copyright © 2019 Jake Tyler. All rights reserved.
//

import Foundation
import MapKit

class PostFlagView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let post = newValue as? Post else {return}
            canShowCallout = true
//            calloutOffset = CGPoint(x: -5, y: 5)
//            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)  // Default callout
            
            // Custom callout button:
            let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 30, height: 30)))
            rightCalloutAccessoryView = mapsButton
            // End custom callout button
            
            if post.locked {
                image = UIImage(named: Constants.LOCKED_POST_IMAGE)
                mapsButton.setBackgroundImage(UIImage(named: "locked-detail.png"), for: UIControl.State())
            } else {
                image = UIImage(named: Constants.UNLOCKED_POST_IMAGE)
                mapsButton.setBackgroundImage(UIImage(named: "forward.png"), for: UIControl.State())
            }
        }
    }
}
