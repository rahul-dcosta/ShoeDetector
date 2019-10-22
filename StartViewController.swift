//
//  StartViewController.swift
//  ShoeScan
//
//  This is the view controller in which the user can initiate logging in to
//  account or signing up.
//
//  In this view controller, the login session is managed by Firebase such that
//  the previous user remains logged in if they have not tapped the
//  "LOG OUT" button in HomeViewController.swift
//
//  Crashlytics enabled
//
//  Created by Rahul D'Costa on 6/12/19.
//  Copyright © 2019 Nihilent Ltd. All rights reserved.
//

import UIKit
import Firebase
import Fabric
import Crashlytics

class StartViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "alreadyLoggedIn", sender: nil)
        }

    }
    
    // The following code hides the navigation controller
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
}
