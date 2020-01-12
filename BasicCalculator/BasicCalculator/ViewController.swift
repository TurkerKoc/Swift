//
//  ViewController.swift
//  BasicCalculator
//
//  Created by Turker Koc on 28.05.2018.
//  Copyright © 2018 Turker Koc. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{

    @IBOutlet weak var textfield1: UITextField!
    @IBOutlet weak var textfield2: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    var result : Double = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        resultLabel.text = ""
        
        
    }

    @IBAction func toplama(_ sender: Any)
    {
        
        //var result = Int(textfield1.text!)! + Int(textfield2.text!)!
        //Birinci ünlem gerçekten text olucağını belirtmek için konuldu
        //İkinci ünlem Bu texti ben integer a çevirebilirsin demek için
        //ama bu kodu kullanmıyoruz çünkü kullanıcı input olarak 5 yerine beş yazarsa kod çöker
        if let firstNumber = Double(textfield1.text!)
        {
            if let secondNumber = Double(textfield2.text!)
            {
                result = firstNumber + secondNumber
                resultLabel.text = String(result)
            }
        }
        
    }
    
    @IBAction func cikarma(_ sender: Any)
    {
        
        if let firstNumber = Double(textfield1.text!)
        {
            if let secondNumber = Double(textfield2.text!)
            {
                result = firstNumber - secondNumber
                resultLabel.text = String(result)
            }
        }
        
    }
    
    @IBAction func carpma(_ sender: Any)
    {
        if let firstNumber = Double(textfield1.text!)
        {
            if let secondNumber = Double(textfield2.text!)
            {
                result = firstNumber * secondNumber
                resultLabel.text = String(result)
            }
        }
    }
    
    @IBAction func bolme(_ sender: Any)
    {
        if let firstNumber = Double(textfield1.text!)
        {
            if let secondNumber = Double(textfield2.text!)
            {
                if secondNumber != 0
                {
                    result = firstNumber / secondNumber
                    resultLabel.text = String(result)
                }
                else
                {
                    resultLabel.text = "Error"
                }
            }
        }
    }
    
}

