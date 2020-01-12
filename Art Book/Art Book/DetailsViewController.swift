//
//  DetailsViewController.swift
//  Art Book
//
//  Created by Turker Koc on 7.06.2018.
//  Copyright © 2018 Turker Koc. All rights reserved.
//

import UIKit
import CoreData //coredata fonksiyonları kullanmak için lazım


//uygulamayı ilk kurarken core data kısmını seç ayrıca .xcdatamodeld uzantılı dosyada attribute kısmını ayarla



class DetailsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
    //Bu ikisi resim seçimi için lazım(self hatası gider)
{
    
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var NameText: UITextField!
    @IBOutlet weak var ArtistText: UITextField!
    @IBOutlet weak var YearText: UITextField!
    var chosenPainting = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        //Böyle deme sebebimiz viewcontroller da segue yaparken eğer eklediğimiz şeye bakmak istiyorsak onu choosen paining içine attık istemiyosak onu "" boşluğa eşitledik yani sadece + tıklandığında boşluk olur
        if chosenPainting != ""
        {
            //aşağısı seçilen isimdeki veriyi çekme işlemi
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Paintings")
            
            //fetchRequest e kısıtlama koyduk kendi istediğimiz name i yazdırmak için
            fetchRequest.predicate = NSPredicate(format: "name = %@",self.chosenPainting)
            
            fetchRequest.returnsObjectsAsFaults = false
            
            
            do
            {
                let results = try context.fetch(fetchRequest)
                
                if results.count>0
                {
                    for result in results as! [NSManagedObject]
                    {
                        if let name = result.value(forKey: "name") as? String
                        {
                            NameText.text = name
                        }
                        if let year = result.value(forKey: "year") as? Int
                        {
                            YearText.text = String(year)
                        }
                        if let artist = result.value(forKey: "artist") as? String
                        {
                            ArtistText.text = artist
                        }
                        if let imageData = result.value(forKey: "image") as? Data
                        {
                            let image = UIImage(data: imageData)
                            self.ImageView.image = image
                        }
                    }
                }
            }catch{
                print("Error")
            }
            
            
        }
        
        
        
        
        //gesture recognizer for image
        ImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DetailsViewController.selectImage))
        ImageView.addGestureRecognizer(gestureRecognizer)

        
        //aşağısı herhangi bir yere dokununca klavyeyi kapatmak için
        view.isUserInteractionEnabled = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DetailsViewController.dismissKeyboard))
        
        
        view.addGestureRecognizer(tap)
        
    }
    
    //klavye kapatma fonksiyonu
    @objc func dismissKeyboard()
    {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    //image tıklama fonk
    @objc func selectImage()
    {
        //Telefondan resim seçme
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary //resim nerden alıncak
        picker.allowsEditing = true //aldığımız resimi editleyebilicek mi
        present(picker, animated: true, completion: nil)
        
    }
    
    //fotoğraf seçildikten sonra olacaklar
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        ImageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        //bizim image yerimize editlenmiş image ı UIImage olarak kaydet
        self.dismiss(animated: true, completion: nil ) //ekranı kapatma
    }
    //!!!! bunu yaptıktan sonra Info.plist den kullanıcıdan privacy photo library e ulaşma izni iste

    
    
    //kaydetmek için fonksiyon
    @IBAction func SaveButtonClicked(_ sender: Any)
    {
        //app delegate tek bir sabit olarak tanımlanır (bizim dosyalarımızdan biri )
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        //yukardaki ikisini yapınca artık kaydetmeye başlayabiliriz
        
        let newArt = NSEntityDescription.insertNewObject(forEntityName: "Paintings", into: context)
        //Art_Book.xcdatamodeld içinde adını Paintings koymuştuk zaten context i de şimdi oluşturduk
        
        
        
        //esas kaydetme kısmı
        newArt.setValue(NameText.text, forKey: "name") //key -> Art_Book.xcdatamodeld içindeki name
        newArt.setValue(ArtistText.text, forKey: "artist")
        
        if let year = Int(YearText.text!)
        {
            newArt.setValue(year, forKey: "year")
        }
        
        let data = UIImageJPEGRepresentation(ImageView.image!, 0.5) //0.5 compression ile kaydetme
        newArt.setValue(data, forKey: "image")
        
        
        do
        {
            try context.save() //yaptıklarımızı kaydetmeye çalış
            print("succesful")
        }catch{
            print("error")
        }
        //throw hatasını verdiği için try komutunu kullanıyoruz
        //ancak denediğinde hata çıkarsa diye denemiyor bunun içinde do catch komutu kullanılır
        
        
        
        
        //viewController lar arası iletişim sağlar new painting geldi haber veriyoruz
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newPainting"), object: nil)
        
        
        
        //save button tıklandıktan sonra tableview olan yere geri dönmek
        //popViewController önceki yere git demek
        self.navigationController?.popViewController(animated: true)
        
        
    }
    

}
