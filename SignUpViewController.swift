//
//  SignUpViewController.swift
//  ShoeScan
//
//  This is the view controller in which the user may sign up their account.
//  
//  The account credentials are stored in the same Firebase database as
//  mentioned for LoginViewController.swift
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

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var signUpButton: CustomButton!
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordConfirm: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        email.delegate = self
        password.delegate = self
        passwordConfirm.delegate = self
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneClicked))
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        
        email.inputAccessoryView = toolBar
        password.inputAccessoryView = toolBar
        passwordConfirm.inputAccessoryView = toolBar
        
    }
    
    @objc func doneClicked() {
        view.endEditing(true)
    }

    
    @IBAction func signUpAction(_ sender: Any) {
        
        if password.text != passwordConfirm.text {
            let alertController = UIAlertController(title: "Passwords do not match", message: "Please enter matching passwords.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
            
        else {
            
            activityIndicator.startAnimating()
            
            // New account created and added to Firebase database
            Auth.auth().createUser(withEmail: email.text!, password: password.text!){ (user, error) in
                
                if error == nil {
                    self.performSegue(withIdentifier: "signupToHome", sender: self)
                    Analytics.logEvent(AnalyticsEventSignUp, parameters: [
                        AnalyticsParameterMethod: self.method
                        ])
                    self.activityIndicator.stopAnimating()
                }
                    
                else {
                    let alertController = UIAlertController(title: "Error signing up", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                    
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    self.activityIndicator.stopAnimating()
                }
                
            }
        }
    }
    
    // The following function dimisses the keyboard upon tapping the "return" key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
 
}
