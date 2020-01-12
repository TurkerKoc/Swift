//
//  ViewController.swift
//  LandMarkBook
//
//  Created by Turker Koc on 30.05.2018.
//  Copyright © 2018 Turker Koc. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource //yeni tanım
{
    
    @IBOutlet weak var TableView: UITableView! //Table view ayarını yapmak lazım data source ve delegation ayarı
    
    var LandmarkNames = [String]()
    var LandmarkImages = [UIImage]()
    
    var SelectedLandMarkName = ""
    var SelectedLandMarkImage = UIImage()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        TableView.dataSource = self
        TableView.delegate = self
        
        LandmarkNames.append("Colloseum")
        LandmarkNames.append("Great Wall")
        LandmarkNames.append("Kremlin")
        LandmarkNames.append("Stonehenge")
        LandmarkNames.append("Taj Mahal")
        
        
        LandmarkImages.append(UIImage(named: "colosseum.jpg")!)
        LandmarkImages.append(UIImage(named: "greatwall.jpg")!)
        LandmarkImages.append(UIImage(named: "kremlin.jpg")!)
        LandmarkImages.append(UIImage(named: "stonehenge.jpg")!)
        LandmarkImages.append(UIImage(named: "tajmahal.jpg")!)
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) //func for segue
    {
        if segue.identifier == "ToImageViewController"
        {
            let destinationVC = segue.destination as! ImageViewController
            destinationVC.LandMarkName = SelectedLandMarkName
            destinationVC.LandMarkImage = SelectedLandMarkImage
            
            
        }
    }

    
    //TableView için bu fonksiyonlar şart   UITableViewDelegate, UITableViewDataSource  bu classları oluşturup bu iki fonksiyonu oluşturmak lazım.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return LandmarkNames.count // array uzunluğu kadar satır kullanılıcağını belirtiyor
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()
        cell.textLabel?.text = LandmarkNames[indexPath.row] //arrayin içindekileri sıra sıra koyacak
        return cell
    }
    
    
    //Silme için fonksiyon commit editing yaz çıkar
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            LandmarkNames.remove(at: indexPath.row) //name array inden silme
            LandmarkImages.remove(at: indexPath.row) //İmage arrayinden silme
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade) //tableviewdan silme
        }
    }
    
    
    //Segue for selected row (didselect yaz çıkar)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        SelectedLandMarkName = LandmarkNames[indexPath.row]
        SelectedLandMarkImage = LandmarkImages[indexPath.row]
        performSegue(withIdentifier: "ToImageViewController", sender: nil)
        
    }
    
    
    


}

