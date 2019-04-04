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
        static let lockedKey = "lockedKey"
        static let postTimeKey = "postTimeKey"
        static let viewTimeKey = "viewTimeKey"
        static let postIdKey = "postIdKey"
    }
    
    var postId: String
    var toUsername: String
    var fromUsername: String
    var image: UIImage
    var coordinate: CLLocationCoordinate2D
    var locked: Bool
    var distance: Int = -1
    var postTime: TimeInterval
    var viewTime: TimeInterval
    
    var title: String? {
        return fromUsername + "'s post"
    }
    
    var subtitle: String? = "Calculating distance..."
    
    init(postId: String, toUsername: String, fromUsername: String, image: UIImage, coordinate: CLLocationCoordinate2D, locked: Bool, postTime: TimeInterval, viewTime: TimeInterval) {
        self.postId = postId
        self.toUsername = toUsername
        self.fromUsername = fromUsername
        self.image = image
        self.coordinate = coordinate
        self.locked = locked
        
        self.postTime = postTime
        self.viewTime = viewTime
        
        super.init()
    }
    
//    convenience init(toUsername: String, fromUsername: String, image: UIImage, coordinate: CLLocationCoordinate2D) {
//        self.init(toUsername: toUsername, fromUsername: fromUsername, image: image, coordinate: coordinate, locked: true)
//    }

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
        aCoder.encode(locked, forKey: PostKeys.lockedKey)
        aCoder.encode(postTime, forKey: PostKeys.postTimeKey)
        aCoder.encode(viewTime, forKey: PostKeys.viewTimeKey)
        aCoder.encode(postId, forKey: PostKeys.postIdKey)
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
        
        self.locked = aDecoder.decodeBool(forKey: PostKeys.lockedKey)
        
        self.postTime = aDecoder.decodeDouble(forKey: PostKeys.postTimeKey)
        self.viewTime = aDecoder.decodeDouble(forKey: PostKeys.viewTimeKey)
        
        self.postId = aDecoder.decodeObject(forKey: PostKeys.postIdKey) as! String

    }
    
}
