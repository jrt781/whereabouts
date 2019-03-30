//
//  MapViewController.swift
//  whereabouts
//
//  Created by Jake Tyler on 3/29/19.
//  Copyright © 2019 Jake Tyler. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    var needsToCenter = false

    @IBOutlet weak var mapView: MKMapView!
    
    let regionRadius: CLLocationDistance = 1000 // 1000 meters
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)

        mapView.setRegion(coordinateRegion, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.register(PostMarkerView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)

        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        self.needsToCenter = true;
        mapView.showsUserLocation = true
        
        let post = Post(toUsername: "myFriend", fromUsername: "jrtyler", image: UIImage(imageLiteralResourceName: "img_lights.jpg"), coordinate: CLLocationCoordinate2D(latitude: 40.248044, longitude: -111.649270))
        mapView.addAnnotation(post)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        if self.needsToCenter {
            let initialLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
            centerMapOnLocation(location: initialLocation)
            self.needsToCenter = false;
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}





extension MapViewController: MKMapViewDelegate {
    // 1
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        // 2
//        guard let annotation = annotation as? Post else { return nil }
//        // 3
//        let identifier = "marker"
//        var view: MKMarkerAnnotationView
//        // 4
//        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
//            as? MKMarkerAnnotationView {
//            dequeuedView.annotation = annotation
//            view = dequeuedView
//        } else {
//            // 5
//            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//            view.canShowCallout = true
//            view.calloutOffset = CGPoint(x: -5, y: 5)
//            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//        }
//        return view
//    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let post = view.annotation as! Post
        print("user tapped the callout button for", post.fromUsername)
    }
}
