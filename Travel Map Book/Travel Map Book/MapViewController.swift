//
//  ViewController.swift
//  Travel Map Book
//
//  Created by Turker Koc on 11.06.2018.
//  Copyright © 2018 Turker Koc. All rights reserved.
//

import UIKit
import MapKit //map kullanmak için şart
import CoreLocation //kullanıcı konumu için lazım
import CoreData

//MKMapViewDelegate map için şart
//CLLocationManagerDelegate konum için şart
class MapViewController: UIViewController, MKMapViewDelegate,CLLocationManagerDelegate
{

    //kaydeder kaydetmez hata veriyor çözümü viewdidload da
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var commentText: UITextField!
    var locationManager = CLLocationManager() //konum için
    
    var requestCLLocation = CLLocation() //yol tarifi kısmı için
    
    var chosenLatitude = Double() //bunlar save için lazım
    var chosenLongitude = Double()
    
    //veri aktarımı için değişkenler
    var selectedTitle = ""
    var selectedSubtitle = ""
    var selectedLatitude : Double = 0
    var selectedLongitude : Double = 0
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        mapView.delegate = self //tableview gibi şart
        
        locationManager.delegate = self //konum için
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //konumun accuracy ayarı
        locationManager.requestWhenInUseAuthorization() //sadece uygulama kullanılırken konum bulunur
        //locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true;
        //info.plist den kullanıcı iznini hallet
        
        
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.chooseLocation(gestureRecognizer:))) //bu sefer tap değil long tap gesture
        recognizer.minimumPressDuration = 3 //minimum 3 sn bassın
        mapView.addGestureRecognizer(recognizer)
        
        
        
        //aşağısı herhangi bir yere dokununca klavyeyi kapatmak için
        view.isUserInteractionEnabled = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MapViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
        //tableViewdan bişey seçilince yapılacaklar
        if selectedTitle != ""
        {
            let annotation = MKPointAnnotation()
            let coordinate = CLLocationCoordinate2DMake(self.selectedLatitude, self.selectedLongitude) //enlem boylam ayarı
            annotation.coordinate = coordinate
            annotation.title = self.selectedTitle
            annotation.subtitle = self.selectedSubtitle
            self.mapView.addAnnotation(annotation)
            
            nameText.text = self.selectedTitle
            commentText.text = self.selectedSubtitle
        }
    }
    
    @IBAction func myLocationClicked(_ sender: Any)
    {
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func FreeSearchClicked(_ sender: Any)
    {
        locationManager.stopUpdatingLocation()
    }
    
    
    //konum enlem ve boylam ayarı
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = CLLocationCoordinate2DMake(locations[0].coordinate.latitude, locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05) //ne kadar zoom yapılcağının ayarı
        let region = MKCoordinateRegion(center: location, span: span) // bulunduğumuz bölge ayarı location ve span yarattık
        mapView.setRegion(region, animated: true)
    }
    
    
    //pin yaratma
    @objc func chooseLocation(gestureRecognizer : UILongPressGestureRecognizer)
    {
        if gestureRecognizer.state == UIGestureRecognizerState.began //eğer başladıysa
        {
            let touchedPoint = gestureRecognizer.location(in: self.mapView) //noktanın alındığı yer
            let choosenCoordinates = self.mapView.convert(touchedPoint, toCoordinateFrom: self.mapView)
            
            chosenLatitude = choosenCoordinates.latitude//save button için yaptık
            chosenLongitude = choosenCoordinates.longitude
            
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = choosenCoordinates
            annotation.title = nameText.text
            annotation.subtitle = commentText.text
            self.mapView.addAnnotation(annotation )
        }
    }

    
    //klavye kapatma fonksiyonu
    @objc func dismissKeyboard()
    {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    //var olan pini  özelleştirmek için fonk
    //yanina yol tarifi eklemek rengini değiştirmek gibi
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if annotation is MKUserLocation
        {
            return nil
        }
        let reuseID = "myAnnotation"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MKPinAnnotationView
        
        if pinView == nil
        {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            //buton kısmını ekleyebilir miyim evet
            pinView?.canShowCallout = true
            //rengi mavi yapma
            pinView?.pinTintColor = UIColor.blue
            
            //buton yapımı
            let button = UIButton(type: UIButtonType.detailDisclosure)
            //buton u annotation a ekleme
            pinView?.rightCalloutAccessoryView = button
            
        }
        else
        {
            pinView?.annotation = annotation
        }
        return pinView
    }
    
    //annotation üzerindeki i tuşuna basınca ne olacağını ayarlayan tuş
    //YOL TARİFİ map ile
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
    {
        if selectedLongitude != 0
        {
            if selectedLatitude != 0
            {
                self.requestCLLocation = CLLocation(latitude: selectedLatitude, longitude: selectedLongitude)
            }
        }
        CLGeocoder().reverseGeocodeLocation(requestCLLocation) { (placemarks, error) in
            if let placemark = placemarks //böyle array oluşursa
            {
                if placemark.count > 0
                {
                    let newPlacemark = MKPlacemark(placemark: placemark[0])
                    let item = MKMapItem(placemark: newPlacemark)
                    item.name = self.selectedTitle
                    
                    let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                    item.openInMaps(launchOptions: launchOptions)
                }
            }
        }

    }
    
    
    
    //veriyi kaydetme kısmı
    @IBAction func saveButtonClicked(_ sender: Any)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newPlace = NSEntityDescription.insertNewObject(forEntityName: "Places", into: context)
        
        newPlace.setValue(nameText.text, forKey: "title")
        newPlace.setValue(commentText.text, forKey: "subtitle")
        newPlace.setValue(chosenLongitude, forKey: "longitude")
        newPlace.setValue(chosenLatitude, forKey: "latitude")
        
        do
        {
            try context.save()
            print("saved")
        } catch{
            print("error")
        }
        
        
        //save button basıldıktan sonra tableview yenileme ve oraya dönmek için
        
        //yeni bişey geldi bildirme
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newAnnotation"), object: nil)
        
        //geri dönüş
        self.navigationController?.popViewController(animated: true)
        
    }
    
    


}

