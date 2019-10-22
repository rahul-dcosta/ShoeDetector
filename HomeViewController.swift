//
//  HomeViewController.swift
//  ShoeScan
//
//  This is the view controller in which the user can either take a picture
//  using the device camera or choose an image from the photo library of the
//  device. The resulting image is passed to the next view controller,
//  ImageAnalysisViewController.swift, after the user taps the "CONFIRM" button
//
//  The user may also log out of their account using the "LOG OUT" button, which
//  transfers the current view to StartViewController.swift
//
//  Crashlytics enabled
//
//  Created by Rahul D'Costa on 6/11/19.
//  Copyright © 2019 Nihilent Ltd. All rights reserved.
//

import UIKit
import Firebase
import Fabric
import Crashlytics

class HomeViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    //boolean variable to verify if user has selected/taken image or not
    var imageChosen = false
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        
        // record current user details and log current user as event
        let user = Auth.auth().currentUser
        if let user = user {
            // The user's ID, unique to the Firebase project.
            // Do NOT use this value to authenticate with your backend server,
            // if you have one. Use getTokenWithCompletion:completion: instead.
            let uid = user.uid
            let email = user.email
            
            Analytics.logEvent("get_user", parameters: ["user": uid, "email": email as Any])
            
        }
    }
    
    @IBAction func logOutAction(_ sender: Any) {
        
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        // The following code sends the current view back to Start View Controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initial = storyboard.instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = initial
        
    }
    
    
    @IBAction func takePhoto(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
            imageChosen = true
        }
            
        else {
            let alertController = UIAlertController.init(title: nil, message: "Device has no camera.", preferredStyle: .alert)
            
            let okAction = UIAlertAction.init(title: "Okay", style: .default, handler: {(alert: UIAlertAction!) in
            })
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func chooseImage(_ sender: Any) {
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated: true){
            //After complete
        }
        
        imageChosen = true
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        if imageChosen == true {
            performSegue(withIdentifier: "confirmSegue", sender: sender)
        }
            
        else {
            let alertController = UIAlertController.init(title: nil, message: "No image chosen.", preferredStyle: .alert)
            
            let okAction = UIAlertAction.init(title: "Okay", style: .default, handler: {(alert: UIAlertAction!) in
            })
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // The following code passes the chosen image to the next view controller
        let destinationViewController = segue.destination as! ImageAnalysisViewController
        destinationViewController.imageFinal = imageView.image
    }
    
}

extension HomeViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        picker.dismiss(animated: true, completion: nil)
        
    }
    
}

extension HomeViewController: UINavigationControllerDelegate {
    
}
