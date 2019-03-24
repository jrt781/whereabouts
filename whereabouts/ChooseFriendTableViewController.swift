//
//  ChooseFriendTableViewController.swift
//  whereabouts
//
//  Created by Jake Tyler on 3/23/19.
//  Copyright © 2019 Jake Tyler. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class ChooseFriendTableViewController: UITableViewController {
    
    fileprivate var ref: DatabaseReference!
    fileprivate var storageRef: StorageReference!
    
    var imageData : Data?
    var friendUsernames : [String] = []
    
    func getFriendsData() {
        friendUsernames = UserDefaults.standard.array(forKey: Constants.FRIEND_USERNAMES) as? [String] ?? [String]()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        getFriendsData()
        
        // Create references to Firebase
        self.ref = Database.database().reference()
        self.storageRef = Storage.storage().reference()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Choose Friend"
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendUsernames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseFriendCell", for: indexPath)

        cell.textLabel?.text = friendUsernames[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let friendUsernameToSentTo = friendUsernames[indexPath.row]
        
        guard let imageData = imageData else {
            print("The image data is null!!!")
            return
        }
        
        let alert = UIAlertController(title: nil, message: "Sending...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        
        // Create a reference to the file you want to upload
        let riversRef = storageRef.child("images/rivers.jpg")
        
        // Upload the file to the path "images/rivers.jpg"
        _ = riversRef.putData(imageData, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                print("There was an error: ", error!.localizedDescription)
                return
            }
            
            // Metadata contains file metadata such as size, content-type.
            _ = metadata.size
            
            // You can also access to download URL after upload.
            riversRef.downloadURL { (url, error) in
                guard url != nil else {
                    print("There was an error: ", error!.localizedDescription)
                    return
                }
            }
            
            // Dismiss loading icon
            self.dismiss(animated: false, completion: nil)
            
            // Return to camera view
            self.navigationController?.popViewController(animated: true)

        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
