//
//  TableViewController.swift
//  Travel Map Book
//
//  Created by Turker Koc on 13.06.2018.
//  Copyright © 2018 Turker Koc. All rights reserved.
//

import UIKit
import CoreData


class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource //table view için lazım
{

    @IBOutlet weak var TableView: UITableView!
    var titleArray = [String]()
    var subtitleArray = [String]()
    var longitudeArray = [Double]()
    var latitudeArray = [Double]()
    
    //veri aktarımı için değişkenler
    var selectedTitle = ""
    var selectedSubtitle = ""
    var selectedLatitude : Double = 0
    var selectedLongitude : Double = 0
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        TableView.delegate = self //tableview için şart
        TableView.dataSource = self
        
        fetchData()
    }
    
    //viewdidload uygulama her açıldığında çalışır anca viewWillAppear her bu VC a geldiğimizde açılır
    //yeni annotation geldiğinde kullanılacak
    override func viewWillAppear(_ animated: Bool)
    {
         NotificationCenter.default.addObserver(self, selector: #selector(TableViewController.fetchData), name: NSNotification.Name(rawValue: "newAnnotation"), object: nil)
    }
    
    
    //TableView Fonksiyonları 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return titleArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()
        cell.textLabel?.text = titleArray[indexPath.row]
        return cell
    }

    
    @IBAction func addButtonClicked(_ sender: Any)
    {
        selectedTitle = ""
        performSegue(withIdentifier: "ToMapVC", sender: nil)
    }
    
    //segue için fonksiyonlar
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        selectedTitle = titleArray[indexPath.row]
        selectedSubtitle = subtitleArray[indexPath.row]
        selectedLatitude = latitudeArray[indexPath.row]
        selectedLongitude = longitudeArray[indexPath.row]
        
        performSegue(withIdentifier: "ToMapVC", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "ToMapVC"
        {
            let destinationVC = segue.destination as! MapViewController
            destinationVC.selectedTitle = self.selectedTitle
            destinationVC.selectedSubtitle = self.selectedSubtitle
            destinationVC.selectedLongitude = self.selectedLongitude
            destinationVC.selectedLatitude = self.selectedLatitude
        }
    }
    
    //silme fonk
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        
        
        if editingStyle == .delete
        {
            titleArray.remove(at: indexPath.row)
            subtitleArray.remove(at: indexPath.row)
            longitudeArray.remove(at: indexPath.row)
            latitudeArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
            
            let result = try? context.fetch(fetchRequest)
            let resultData = result as! [NSManagedObject]
            
            
            print(indexPath.row)
            
            context.delete(resultData[indexPath.row])
            
            
            
        }
        
    }
    
    
    //veriyi çekme kısmı
    @objc func fetchData()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let Request = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
        Request.returnsObjectsAsFaults = false
        
        do
        {
            let results = try context.fetch(Request)
            
            if results.count>0
            {
                self.titleArray.removeAll()
                self.subtitleArray.removeAll()
                self.latitudeArray.removeAll()
                self.longitudeArray.removeAll()
                
                for result in results as! [NSManagedObject]
                {
                    if let title = result.value(forKey: "title") as? String
                    {
                        self.titleArray.append(title)
                    }
                    if let subtitle = result.value(forKey: "subtitle") as? String
                    {
                        self.subtitleArray.append(subtitle)
                    }
                    if let latitude = result.value(forKey: "latitude") as? Double
                    {
                        self.latitudeArray.append(latitude)
                    }
                    if let longitude = result.value(forKey: "longitude") as? Double
                    {
                        self.longitudeArray.append(longitude)
                    }
                    self.TableView.reloadData()
                }
            }
        } catch {
            print("error")
        }
    }
    

}
