//
//  ViewController.swift
//  SimpsonBook-TableViewWithClasses
//
//  Created by Turker Koc on 31.05.2018.
//  Copyright © 2018 Turker Koc. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {


    @IBOutlet weak var TableView: UITableView!
    
    var mySimpsons = [Simpson]()
    var mySelectedSimpson = Simpson()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        TableView.dataSource = self //bu ikisi table view içi şart
        TableView.delegate = self
        
        
        //Simpson Class
        let bart = Simpson()
        bart.name = "Bart Simpson"
        bart.occupation = "Student"
        bart.image = UIImage(named: "bart.png")!
        
        let homer = Simpson()
        homer.name = "Homer Simpson"
        homer.occupation = "Safety Nuclear Inspector"
        homer.image = UIImage(named: "homer.png")!
        
        let lisa = Simpson()
        lisa.name = "Lisa Simpson"
        lisa.occupation = "Student"
        lisa.image = UIImage(named: "lisa")!
        
        let maggie = Simpson()
        maggie.name = "Maggie Simpson"
        maggie.occupation = "Student"
        maggie.image = UIImage(named: "maggie.png")!
        
        let marge = Simpson()
        marge.name = "Marge Simpson"
        marge.occupation = "Home Maker"
        marge.image = UIImage(named: "marge.png")!
        
        
        //Simpson Array
        mySimpsons.append(bart)
        mySimpsons.append(homer)
        mySimpsons.append(lisa)
        mySimpsons.append(maggie)
        mySimpsons.append(marge)
        
    }
    
    //Segue func
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "ToDetailsVC"
        {
            let destinationVC = segue.destination as! DetailsViewController
            destinationVC.SelectedSimpson = mySelectedSimpson
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        mySelectedSimpson = mySimpsons[indexPath.row]
        performSegue(withIdentifier: "ToDetailsVC", sender: nil)
        
    }
    
    
    
    //alttaki iki fonk table view için şart
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return mySimpsons.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = mySimpsons[indexPath.row].name
        //önceden array içinde sadece isim vardı şimdi class tamamen orda olduğu için .name dedik
        
        return cell
    }
    



}

