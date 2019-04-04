//
//  MapViewController.swift
//  whereabouts
//
//  Created by Jake Tyler on 3/29/19.
//  Copyright © 2019 Jake Tyler. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import FirebaseStorage

class MapViewController: UIViewController, LocationObserver {

    fileprivate var ref: DatabaseReference!
    fileprivate var storageRef: StorageReference!
    
    let locationManager = CLLocationManager()
    var needsToCenter = false
    var posts: [Post] = []

    @IBOutlet weak var mapView: MKMapView!
    
    let regionRadius: CLLocationDistance = 250 // 250 meters
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)

        mapView.setRegion(coordinateRegion, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create references to Firebase
        self.ref = Database.database().reference()
        self.storageRef = Storage.storage().reference()
        
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
        
        // TODO improve map marker instructions so new people aren't confused
        
//        let post = Post(postId: "12", toUsername: "jrtyler", fromUsername: "myFriend", image: UIImage(imageLiteralResourceName: "img_lights.jpg"), coordinate: CLLocationCoordinate2D(latitude: 37.787392, longitude: -122.408189), locked: false, postTime: 1553962641.8981, viewTime: 1553969842.477964)
//
//        mapView.addAnnotation(post)
//        posts.append(post)
//
//        let post2 = Post(postId: "13", toUsername: "jrtyler", fromUsername: "myFriend2", image: UIImage(imageLiteralResourceName: "img_lights.jpg"), coordinate: CLLocationCoordinate2D(latitude: 40.247007, longitude: -111.648264), locked: false, postTime: 1553962641.8981, viewTime: 1553969842.477964)
//
//        mapView.addAnnotation(post2)
//        posts.append(post2)
        
        guard let currentUsername = UserDefaults.standard.string(forKey: Constants.CURRENT_USERNAME) else {
            // Error: user is not logged in somehow?? Just log them out
            UserDefaults.standard.set(false, forKey: Constants.IS_LOGGED_IN)
            Switcher.updateRootVC()
            return
        }
        
        let _ = ref.child("users").child(currentUsername).child("postsFromFriends").observeSingleEvent(of: DataEventType.value) { (snapshot) in
            let posts = snapshot.value as? [String : AnyObject] ?? [:]
            for (key, _) in posts {
                self.ref.child("posts").child(key).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                    let postDict = snapshot.value as? [String : AnyObject] ?? [:]
                    let toUsername = postDict["toUsername"] as! String
                    let fromUsername = postDict["fromUsername"] as! String
                    let lat = postDict["latitude"] as! Double
                    let long = postDict["longitude"] as! Double
                    let imageId = postDict["imageId"] as! String
                    let locked = postDict["locked"] as! Bool
                    let postTime = postDict["postTime"] as! TimeInterval
                    let viewTime = postDict["viewTime"] as! TimeInterval
                    
                    // Create a reference to the file you want to download
                    let imageRef = self.storageRef.child("images/\(imageId).jpg")
                    
                    // Download in memory with a maximum allowed size of 20MB (20 * 1024 * 1024 bytes)
                    imageRef.getData(maxSize: 20 * 1024 * 1024) { data, error in
                        if error != nil {
                            print("There was an error: ", error!.localizedDescription)
                        } else {
                            // Data for "images/island.jpg" is returned
                            let image = UIImage(data: data!)
                            
                            let post = Post(postId: key, toUsername: toUsername, fromUsername: fromUsername, image: image!, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long), locked: locked, postTime: postTime, viewTime: viewTime)
                            self.mapView.addAnnotation(post)
                            self.posts.append(post)
                        }
                    }
                })
            }
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
    
    // TODO store posts in model?????
    // TODO appropriately tell users that they can't open image of locked posts
    // TODO Record the times the posts were made and when they were unlocked and/or seen, and display the most recent posts
    // TODO allow users to post photos from library
    
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
                    self.ref.child("posts").child(post.postId).child("locked").setValue(false)
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
