//
//  MapViewController.swift
//  whereabouts
//
//  Created by Jake Tyler on 3/29/19.
//  Copyright © 2019 Jake Tyler. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, LocationObserver {

    let locationManager = CLLocationManager()
    var needsToCenter = false
    var posts: [Post] = []

    @IBOutlet weak var mapView: MKMapView!
    
    let regionRadius: CLLocationDistance = 100 // 100 meters
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)

        mapView.setRegion(coordinateRegion, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.register(PostFlagView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        //PostFlagView -- only an image
        //PostMarkerView -- wrapped in a built-in pin
        
        LocationManager.shared.addLocationObserver(observer: self)
        if let currentLocation = LocationManager.shared.userLocation {
            centerMapOnLocation(location: currentLocation)
            onLocationUpdate(userLocation: currentLocation)
        }
        
        
        self.needsToCenter = true;
        mapView.showsUserLocation = true
        
        let post = Post(toUsername: "jrtyler", fromUsername: "myFriend", image: UIImage(imageLiteralResourceName: "img_lights.jpg"), coordinate: CLLocationCoordinate2D(latitude: 37.787392, longitude: -122.408189))
        
        mapView.addAnnotation(post)
        posts.append(post)
        
        let post2 = Post(toUsername: "jrtyler", fromUsername: "myFriend2", image: UIImage(imageLiteralResourceName: "img_lights.jpg"), coordinate: CLLocationCoordinate2D(latitude: 40.247007, longitude: -111.648264))
        
        mapView.addAnnotation(post2)
        posts.append(post2)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // TODO store posts in model?????
    // TODO appropriately tell users that they can't open image of locked posts
    // TODO get posts from friends even when app is closed
    
    func onLocationUpdate(userLocation: CLLocation) {
        var selectedAnnotation: Post?
        if mapView.selectedAnnotations.count > 0 {
            selectedAnnotation = mapView.selectedAnnotations[0] as? Post
        }
        for post in self.posts {
            // Unlocked posts don't need to be updated with position
            if post.locked {
                
                // Generate distance data
                let oldDistance = post.distance
                let distance = Int(userLocation.distance(from: CLLocation(latitude: post.coordinate.latitude, longitude: post.coordinate.longitude)))
                
                // Check if the distance is within the unlocked region
                if distance < 15 {
                    post.locked = false
                }
                
                // If the distance has changed, update the markers
                if oldDistance != distance {
                    post.subtitle = post.locked ? "\(distance) meters away" : "Unlocked!"
                    mapView.removeAnnotation(post)
                    mapView.addAnnotation(post)
                    if post == selectedAnnotation {
                        mapView.selectAnnotation(post, animated: false)
                    }
                }
            }
        }
    }
    
    var selectedPost : Post?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "viewPostFromMap") {
            guard let selectedPost = selectedPost else {
                return
            }
            let destinationVC = segue.destination as! PostViewController
            destinationVC.post = selectedPost
        }
    }

}


extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let post = view.annotation as! Post
        if !post.locked {
            self.selectedPost = post
            self.performSegue(withIdentifier: "viewPostFromMap", sender: self)
        }
        
    }
    
}
