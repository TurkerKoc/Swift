//
//  ViewController.swift
//  Currency Convert
//
//  Created by Turker Koc on 10.07.2018.
//  Copyright © 2018 Turker Koc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cadLabel: UILabel!
    @IBOutlet weak var tryLabel: UILabel!
    @IBOutlet weak var gbpLabel: UILabel!
    @IBOutlet weak var jpyLabel: UILabel!
    @IBOutlet weak var chfLabel: UILabel!
    @IBOutlet weak var usdLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
    }


    @IBAction func GetRates(_ sender: Any)
    {
        //Veri alacağımız url yi oluşturduk
        let url = URL(string: "http://data.fixer.io/api/latest?access_key=78355a1b0e4b21226c5a2558770df560")
        //http güvenlik önlemi almak için info.plist den app transport security settings seç ardından onun içinde allow arbitrary loads kur ve onu yes yap
        
        let session = URLSession.shared
        
        //task ya hata ya da data cevap vericek
        let task = session.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            //Hata varsa bunu bildirim olarak çıkartma
            if error != nil
            {
                let alert = UIAlertController(title: "Hata", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let okButton = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil )
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
                //hata yoksa yapılacaklar
            else
            {
                if data != nil
                {
                    
                    do
                    {
                        let JSONResult = try
                            JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, AnyObject>
                        //String e anyobject yaptık ki aldığımız veri string->boolean da olabiliyor
                        
                        //JSONResult bunun içinde işlenir esas veri burada çekilir
                        //async yapmazsak yüksek veri download ederken app kitlenirdi async arka planda download eder
                        DispatchQueue.main.async
                            {
                                
                                
                                //aldığımız verileri bir array içine attık gereklileri oradan çekiyoruz
                                let rates = JSONResult["rates"] as! [String:AnyObject]
                                
                                //tl kısmının verisini çekip doldurma
                                let tl = String(describing: rates["TRY"]!)
                                self.tryLabel.text = "TRY: \(tl)"
                                
                                let cad = String(describing: rates["CAD"]!)
                                self.cadLabel.text = "CAD: \(cad)"
                                
                                let gbp = String(describing: rates["GBP"]!)
                                self.gbpLabel.text = "GBP: \(gbp)"
                                
                                let jpy = String(describing: rates["JPY"]!)
                                self.jpyLabel.text = "JPY: \(jpy)"
                                
                                let chf = String(describing: rates["CHF"]!)
                                self.chfLabel.text = "CHF: \(chf)"
                                
                                let usd = String(describing: rates["USD"]!)
                                self.usdLabel.text = "USD: \(usd)"
                                
                                
                        }
                        
                    }catch{
                        
                    }
                }
            }
        })
        task.resume()

    }
    

}

