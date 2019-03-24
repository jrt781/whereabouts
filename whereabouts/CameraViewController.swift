//
//  CameraViewController.swift
//  whereabouts
//
//  Created by Jake Tyler on 3/12/19.
//  Copyright © 2019 Jake Tyler. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class CameraViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    var imagePicker: UIImagePickerController!
    
    fileprivate var ref: DatabaseReference!
    fileprivate var storageRef: StorageReference!
    
    /** @var handle
     @brief The handler for the auth state listener, to allow cancelling later.
     */
    var handle: AuthStateDidChangeListenerHandle?
    
    @IBAction func takePhoto(_ sender: Any) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            // ...
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // Create references to Firebase
        self.storageRef = Storage.storage().reference()
        self.ref = Database.database().reference()
        
//        ref.child("users").child("yeet").setValue(["username": "yo mama"])

        // Create a reference to the file you want to download
        let riversRef = storageRef.child("images/rivers.jpg")

        // Download in memory with a maximum allowed size of 20MB (20 * 1024 * 1024 bytes)
        riversRef.getData(maxSize: 20 * 1024 * 1024) { data, error in
            if error != nil {
                print("There was an error: ", error!.localizedDescription)
            } else {
                // Data for "images/island.jpg" is returned
                self.imageView.image = UIImage(data: data!)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        imageView.image = info[.originalImage] as? UIImage
        
        self.performSegue(withIdentifier: "chooseFriend", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "chooseFriend") {
            // Data in memory
            let dataAttempt = imageView?.image?.jpegData(compressionQuality: 1.0)
            
            guard let data = dataAttempt else {
                // Uh-oh, an error occurred!
                return
            }
            
            // Create a new variable to store the instance of PlayerTableViewController
            let destinationVC = segue.destination as! ChooseFriendTableViewController
            destinationVC.imageData = data
        }
    }

}

