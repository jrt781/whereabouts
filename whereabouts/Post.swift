//
//  Post.swift
//  whereabouts
//
//  Created by Jake Tyler on 3/29/19.
//  Copyright © 2019 Jake Tyler. All rights reserved.
//

import Foundation
import MapKit

class Post: NSObject, MKAnnotation, NSCoding {
    
    struct PostKeys {
        static let toUsernameKey = "toUsernameKey"
        static let fromUsernameKey = "fromUsernameKey"
        static let imageKey = "imageKey"
        static let latKey = "latKey"
        static let longKey = "longKey"
    }
    
    let toUsername: String
    let fromUsername: String
    let image: UIImage
    let coordinate: CLLocationCoordinate2D
    
    var title: String? {
        return toUsername + "'s post"
    }
    
    var subtitle: String? {
        return ""
    }
    
    init(toUsername: String, fromUsername: String, image: UIImage, coordinate: CLLocationCoordinate2D) {
        self.toUsername = toUsername
        self.fromUsername = fromUsername
        self.image = image
        self.coordinate = coordinate
        
        super.init()
    }
    
//    convenience init?(toUsername: String, fromUsername: String, image: UIImage, coordinate: CLLocationCoordinate2D) {
//        guard let imageData = image.jpegData(compressionQuality: 1) else {
//            return nil
//        }
//        self.init(toUsername: toUsername, fromUsername: fromUsername, imageData: imageData, coordinate: coordinate)
//    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(toUsername, forKey: PostKeys.toUsernameKey)
        aCoder.encode(fromUsername, forKey: PostKeys.fromUsernameKey)
        aCoder.encode(image.jpegData(compressionQuality: 1), forKey: PostKeys.imageKey)
        aCoder.encode(coordinate.latitude as Double, forKey: PostKeys.latKey)
        aCoder.encode(coordinate.longitude as Double, forKey: PostKeys.longKey)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.toUsername = aDecoder.decodeObject(forKey: PostKeys.toUsernameKey) as! String
        self.fromUsername = aDecoder.decodeObject(forKey: PostKeys.fromUsernameKey) as! String
        
        guard let imageData = aDecoder.decodeData() else {
            return nil
        }
        self.image = UIImage(data: imageData)!
        
        let lat = aDecoder.decodeDouble(forKey: PostKeys.latKey)
        let long = aDecoder.decodeDouble(forKey: PostKeys.longKey)
        self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
    
}
