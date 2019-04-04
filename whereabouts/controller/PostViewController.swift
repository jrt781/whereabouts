//
//  PostViewController.swift
//  whereabouts
//
//  Created by Jake Tyler on 3/23/19.
//  Copyright © 2019 Jake Tyler. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class PostViewController: UIViewController {
    
    fileprivate var ref: DatabaseReference!
    fileprivate var storageRef: StorageReference!
    
    var postId : String = ""
    var post : Post?

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var fromUsernameTextView: UITextView!
    @IBOutlet weak var sentAtTextView: UITextView!
    @IBOutlet weak var viewedAtTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Create references to Firebase
        self.ref = Database.database().reference()
        self.storageRef = Storage.storage().reference()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a MMM dd, yyyy"
        
        if !postId.isEmpty {
            print("Getting data from firebase using the post id that was passed in:", postId)
            ref.child("posts").child(postId).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
            
                let fromUsername = value?["fromUsername"] as? String ?? "Error"
                self.fromUsernameTextView.text = fromUsername

                let sentAt = value?["postTime"] as? TimeInterval ?? 0.0
                self.sentAtTextView.text = dateFormatter.string(from: Date(timeIntervalSince1970: sentAt))
                
                var viewedAt = value?["viewTime"] as? TimeInterval ?? 0.0
                if viewedAt < 1 {
                    viewedAt = NSDate().timeIntervalSince1970
                    self.ref.child("posts").child(self.postId).child("viewTime").setValue(viewedAt)
                }
                self.viewedAtTextView.text = dateFormatter.string(from: Date(timeIntervalSince1970: viewedAt))
                
                let imageId = value?["imageId"] as? String ?? "Error"
                // Create a reference to the file you want to download
                let imageRef = self.storageRef.child("images/\(imageId).jpg")
            
                // Download in memory with a maximum allowed size of 20MB (20 * 1024 * 1024 bytes)
                imageRef.getData(maxSize: 20 * 1024 * 1024) { data, error in
                    if error != nil {
                        print("There was an error: ", error!.localizedDescription)
                    } else {
                        // Data for "images/island.jpg" is returned
                        self.imageView.image = UIImage(data: data!)
                    }
                }
            
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        
        if let strongPost = post {
            print("Getting data from post that was passed in:", strongPost)
            if strongPost.locked {
                self.imageView.image = UIImage(named: Constants.LOCKED_POST_IMAGE)
            } else {
                self.imageView.image = strongPost.image
            }
            self.fromUsernameTextView.text = strongPost.fromUsername
            
            // has the post been marked as viewed yet?
            if strongPost.viewTime < 1 {
                
                // Get the time and store it
                strongPost.viewTime = NSDate().timeIntervalSince1970
                
                // Check if the post *has* been viewed but we don't have the updated one
                self.ref.child("posts").child(strongPost.postId).child("viewTime").observeSingleEvent(of: DataEventType.value) { (snapshot) in
                    let viewTime = snapshot.value as! TimeInterval
                    if viewTime < 1 {
                        // The database needs to be updated with the time it was just viewed at
                        self.ref.child("posts").child(strongPost.postId).child("viewTime").setValue(strongPost.viewTime)
                    } else {
                        // We don't have the updated time. Let's get it and update the view if needed
                        strongPost.viewTime = viewTime
                        self.viewedAtTextView.text = dateFormatter.string(from: Date(timeIntervalSince1970: strongPost.viewTime))
                    }
                }
            }
            
            self.sentAtTextView.text = dateFormatter.string(from: Date(timeIntervalSince1970: strongPost.postTime))
            
            self.viewedAtTextView.text = dateFormatter.string(from: Date(timeIntervalSince1970: strongPost.viewTime))
            
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
