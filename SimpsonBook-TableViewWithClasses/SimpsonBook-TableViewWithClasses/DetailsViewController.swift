//
//  DetailsViewController.swift
//  SimpsonBook-TableViewWithClasses
//
//  Created by Turker Koc on 31.05.2018.
//  Copyright © 2018 Turker Koc. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var OccupationLabel: UILabel! //Occupation -> meslek
    
    var SelectedSimpson = Simpson()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //köşeleri yuvarlak yapma
        NameLabel.layer.masksToBounds = true
        NameLabel.layer.cornerRadius = NameLabel.layer.frame.size.height / 2
        
        OccupationLabel.layer.masksToBounds = true
        OccupationLabel.layer.cornerRadius = 20

        
        
        ImageView.image = SelectedSimpson.image
        NameLabel.text = SelectedSimpson.name
        print(SelectedSimpson.name)
        OccupationLabel.text = SelectedSimpson.occupation
       
        // Do any additional setup after loading the view.
        
        
        
    }



}
