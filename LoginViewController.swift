//
//  LoginViewController.swift
//  ShoeScan
//
//  This is the view controller in which the user enters their credentials to login
//  Account credentials are stored on the FireBase database
//
//  Google account credentials:
//  email: datsmashoe2000@gmail.com
//  password: nihilent123
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


class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: CustomButton!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  enabling toolbar with "Done" button to dismiss keyboard
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneClicked))
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        
        email.inputAccessoryView = toolBar
        password.inputAccessoryView = toolBar
        
    }
    
    @objc func doneClicked() {
        view.endEditing(true)
    }
    
    @IBAction func loginAction(_ sender: Any) {
        
        activityIndicator.startAnimating()
        
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (user, error) in
            
            if error == nil {
                self.performSegue(withIdentifier: "loginToHome", sender: self)
                Analytics.logEvent(AnalyticsEventLogin, parameters: [
                    AnalyticsParameterMethod: self.method
                    ])
                self.activityIndicator.stopAnimating()
            }
                
            else {
                let alertController = UIAlertController(title: "Error logging in", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
                
                self.activityIndicator.stopAnimating()
                
                // crash function
                //Crashlytics.sharedInstance().crash()
            }
            
        }
        
    }
    
}
