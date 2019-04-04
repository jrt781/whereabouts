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
import AVFoundation

class CameraViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, AVCapturePhotoCaptureDelegate {

    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var captureImageView: UIImageView!
    @IBOutlet weak var takePictureButton: UIButton!
    
    var imagePicker: UIImagePickerController!
    
    fileprivate var ref: DatabaseReference!
    fileprivate var storageRef: StorageReference!
    
    // Variables for custom camera
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    /** @var handle
     @brief The handler for the auth state listener, to allow cancelling later.
     */
    var handle: AuthStateDidChangeListenerHandle?
    
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            // ...
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .medium
        
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
            else {
                print("Unable to access back camera!")
                return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            
            stillImageOutput = AVCapturePhotoOutput()
            
            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                setupLivePreview()
            }
        }
        catch let error  {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
        
        takePictureButton.addTarget(self, action: #selector(takePictureButtonPressedDown), for: .touchDown)
        takePictureButton.addTarget(self, action: #selector(takePictureButtonReleased), for: .touchUpInside)
    }
    
    @objc func takePictureButtonPressedDown() {
        takePictureButton.backgroundColor = UIColor.gray
    }
    
    @objc func takePictureButtonReleased() {
        takePictureButton.backgroundColor = UIColor.white
    }
    
    func setupLivePreview() {
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        videoPreviewLayer.videoGravity = .resizeAspect
        videoPreviewLayer.connection?.videoOrientation = .portrait
        previewView.layer.addSublayer(videoPreviewLayer)
        
        DispatchQueue.global(qos: .userInitiated).async { //[weak self] in
            self.captureSession.startRunning()
            DispatchQueue.main.async {
                self.videoPreviewLayer.frame = self.previewView.bounds
            }
        }
    }
    
    // TODO customize "take photo" button
    
    // TODO change camera state once pic is taken:
        // TODO hide preview
        // TODO hide "take photo" button
        // TODO show "retake" button
        // TODO show "send to friends" button
    
    // TODO Let the user retake photo
        // TODO reshow preview
        // TODO reshow "take photo" button
        // TODO hide "send to friends" button
        // TODO hide "retake" button
    
    @IBAction func didTakePhoto(_ sender: Any) {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard let imageData = photo.fileDataRepresentation()
            else { return }
        
        let image = UIImage(data: imageData)
        captureImageView.image = image
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    @IBAction func sendPhotoToFriends(_ sender: Any) {
        self.performSegue(withIdentifier: "chooseFriend", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "chooseFriend") {
            // Data in memory
            let dataAttempt = captureImageView?.image?.jpegData(compressionQuality: 1.0)
            
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

