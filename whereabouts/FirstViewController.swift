//
//  FirstViewController.swift
//  whereabouts
//
//  Created by Jake Tyler on 3/12/19.
//  Copyright © 2019 Jake Tyler. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

class FirstViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    var imagePicker: UIImagePickerController!
    
    @IBAction func takePhoto(_ sender: Any) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Get a reference to the storage service using the default Firebase App
        let storage = Storage.storage()

        // Create a root reference
        let storageRef = storage.reference()
        
        // Create a reference to "mountains.jpg"
        let mountainsRef = storageRef.child("mountains.jpg")
        
        // Create a reference to 'images/mountains.jpg'
        let mountainImagesRef = storageRef.child("images/mountains.jpg")
        
        // While the file names are the same, the references point to different files
        mountainsRef.name == mountainImagesRef.name;            // true
        mountainsRef.fullPath == mountainImagesRef.fullPath;    // false
        
        
        
        var ref: DatabaseReference!
        
        ref = Database.database().reference()
        
        ref.child("users").child("yeet").setValue(["username": "yo mama"])

    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        imageView.image = info[.originalImage] as? UIImage
        
        // Get a reference to the storage service using the default Firebase App
        let storage = Storage.storage()
        
        // Create a root reference
        let storageRef = storage.reference()
        
        // Data in memory
        let dataAttempt = imageView?.image?.jpegData(compressionQuality: 1.0)
        
        guard let data = dataAttempt else {
            // Uh-oh, an error occurred!
            return
        }
        
        // Create a reference to the file you want to upload
        let riversRef = storageRef.child("images/rivers.jpg")
        
        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = riversRef.putData(data, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type.
            let size = metadata.size
            // You can also access to download URL after upload.
            riversRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                }
            }
        }
        
        
        
    }

}

