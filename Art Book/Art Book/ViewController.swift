//
//  ViewController.swift
//  Art Book
//
//  Created by Turker Koc on 7.06.2018.
//  Copyright © 2018 Turker Koc. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {


    @IBOutlet weak var TableView: UITableView!
    
    var nameArray = [String]()
    var yearArray = [Int]()
    var artistArray = [String]()
    var imageArray = [UIImage]()
    var selectedPainting = ""
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        TableView.delegate = self
        TableView.dataSource = self
        
        
        getInfo()
        
        
    }
    
    //viewdidload uygulama her açıldığında çalışır anca viewWillAppear her bu VC a geldiğimizde açılır
    //yeni resim ekleyip geri döndüğümzde TableView da çıksın.
    override func viewWillAppear(_ animated: Bool)
    {
        //DetailsViewController dan gelen yeni resim geldi mesajını alıyoruz ve tableviewı yeniliyoruz
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.getInfo), name: NSNotification.Name(rawValue: "newPainting"), object: nil)
        
    }
    
    
    //segue den önce yapılacaklar
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "toDetailsVC"
        {
            let destinationVC = segue.destination as! DetailsViewController
            destinationVC.chosenPainting = selectedPainting
        }
    }
    
    //func for segue
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        selectedPainting = nameArray[indexPath.row]
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
  

    
    //veriyi çekme kısmı (DetailsViewController da eklenen veriyi tableview a ekleme)
    @objc func getInfo()
    {
        //başlamadan array i boşaltmak iyidir
        nameArray.removeAll(keepingCapacity: false)
        yearArray.removeAll(keepingCapacity: false)
        imageArray.removeAll(keepingCapacity: false)
        artistArray.removeAll(keepingCapacity: false)
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext  //buralar veri kaydetmeyele aynıydı
        
        //burası farklı
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Paintings")
        //fetchRequest amacı datayı çek bana getir demek gibi bişey
        
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try context.fetch(fetchRequest) //bu çıkan sonucu results a yaz
            if results.count > 0
            {
                for result in results as! [NSManagedObject] //Nsmanagedobject olmasını istiyoruz
                {
                    
                    if let name = result.value(forKey: "name") as? String
                    {
                        self.nameArray.append(name)
                        
                    }
                    if let year = result.value(forKey: "year") as? Int
                    {
                        self.yearArray.append(year)
                        
                    }
                    if let artist = result.value(forKey: "artist") as? String
                    {
                        self.artistArray.append(artist)
                        
                    }
                    if let imageData = result.value(forKey: "image") as? Data
                    {
                        let image = UIImage(data: imageData)
                        self.imageArray.append(image!)
                        
                    }
                    self.TableView.reloadData() //table view a bişey ekledim güncelle demek
                }
            }
        }catch{
            print("error")
        
        }
        
    }
    
    
    //tableview için şart fonksiyonlar
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(nameArray.count)
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = nameArray[indexPath.row]
        return cell
    }
    
    
    
    
    
    @IBAction func AddButtonClicked(_ sender: Any)
    {
        selectedPainting = ""
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    
    //silme fonk
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {

        
        if editingStyle == .delete
        {
            nameArray.remove(at: indexPath.row)
            yearArray.remove(at: indexPath.row)
            artistArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Paintings")
            
            let result = try? context.fetch(fetchRequest)
            let resultData = result as! [NSManagedObject]
            
            
            print(indexPath.row)
            
            context.delete(resultData[indexPath.row])
            
            
       
        }
        
    }
    

}

