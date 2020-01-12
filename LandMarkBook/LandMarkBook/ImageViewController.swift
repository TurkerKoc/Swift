//
//  ImageViewController.swift
//  LandMarkBook
//
//  Created by Turker Koc on 30.05.2018.
//  Copyright © 2018 Turker Koc. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var NameLabel: UILabel!
    
    var LandMarkName = ""
    var LandMarkImage = UIImage()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        ImageView.image = LandMarkImage
        NameLabel.text = LandMarkName
        // Do any additional setup after loading the view.
    }


}
