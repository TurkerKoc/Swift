//
//  ViewController.swift
//  Face ID Project
//
//  Created by Turker Koc on 16.06.2018.
//  Copyright © 2018 Turker Koc. All rights reserved.
//

import UIKit
import LocalAuthentication //face id için lazım

class ViewController: UIViewController
{

    @IBOutlet weak var StatusLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let authContext = LAContext()
        
        var error: NSError?
        
        if authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        {
            authContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Gercekten Siz misiniz?", reply: { (success, error) in
                print(success)
                if success == true
                {
                    self.StatusLabel.text = "Success!"
                }
                else
                {
                    self.StatusLabel.text = "No!"
                }
            })
        }
    
    }



}

