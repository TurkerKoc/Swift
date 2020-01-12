//
//  ViewController.swift
//  CatchKenny
//
//  Created by Turker Koc on 30.05.2018.
//  Copyright © 2018 Turker Koc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var ScoreLabel: UILabel!
    @IBOutlet weak var HighScoreLabel: UILabel!
    @IBOutlet weak var Kenny1: UIImageView!
    @IBOutlet weak var Kenny2: UIImageView!
    @IBOutlet weak var Kenny3: UIImageView!
    @IBOutlet weak var Kenny4: UIImageView!
    @IBOutlet weak var Kenny5: UIImageView!
    @IBOutlet weak var Kenny6: UIImageView!
    @IBOutlet weak var Kenny7: UIImageView!
    @IBOutlet weak var Kenny8: UIImageView!
    @IBOutlet weak var Kenny9: UIImageView!
    
    var score = 0
    var timer = Timer()
    var counter = 0
    var KennyArray = [UIImageView]()
    var hidetime = Timer() //for hiding kenny
  
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let Highscore = UserDefaults.standard.object(forKey: "Highscore") //highscore check
        if Highscore == nil
        {
            HighScoreLabel.text = "0"
        }
        if let newScore = Highscore as? Int
        {
            HighScoreLabel.text = String(newScore)
        }
        
        
        ScoreLabel.text = "Score: \(score)"
        
        let recognizer1 = UITapGestureRecognizer(target: self, action: #selector(ViewController.increaseScore ))
        let recognizer2 = UITapGestureRecognizer(target: self, action: #selector(ViewController.increaseScore ))
        let recognizer3 = UITapGestureRecognizer(target: self, action: #selector(ViewController.increaseScore ))
        let recognizer4 = UITapGestureRecognizer(target: self, action: #selector(ViewController.increaseScore ))
        let recognizer5 = UITapGestureRecognizer(target: self, action: #selector(ViewController.increaseScore ))
        let recognizer6 = UITapGestureRecognizer(target: self, action: #selector(ViewController.increaseScore ))
        let recognizer7 = UITapGestureRecognizer(target: self, action: #selector(ViewController.increaseScore ))
        let recognizer8 = UITapGestureRecognizer(target: self, action: #selector(ViewController.increaseScore ))
        let recognizer9 = UITapGestureRecognizer(target: self, action: #selector(ViewController.increaseScore ))
        
        Kenny1.isUserInteractionEnabled = true
        Kenny2.isUserInteractionEnabled = true
        Kenny3.isUserInteractionEnabled = true
        Kenny4.isUserInteractionEnabled = true
        Kenny5.isUserInteractionEnabled = true
        Kenny6.isUserInteractionEnabled = true
        Kenny7.isUserInteractionEnabled = true
        Kenny8.isUserInteractionEnabled = true
        Kenny9.isUserInteractionEnabled = true
        
        Kenny1.addGestureRecognizer(recognizer1)
        Kenny2.addGestureRecognizer(recognizer2)
        Kenny3.addGestureRecognizer(recognizer3)
        Kenny4.addGestureRecognizer(recognizer4)
        Kenny5.addGestureRecognizer(recognizer5)
        Kenny6.addGestureRecognizer(recognizer6)
        Kenny7.addGestureRecognizer(recognizer7)
        Kenny8.addGestureRecognizer(recognizer8)
        Kenny9.addGestureRecognizer(recognizer9)
        
        //timers
        
        counter = 30
        TimeLabel.text = "\(counter)"
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.timerFunction), userInfo: nil, repeats: true)
        
        
        
        //arrays
        KennyArray.append(Kenny1)
        KennyArray.append(Kenny2)
        KennyArray.append(Kenny3)
        KennyArray.append(Kenny4)
        KennyArray.append(Kenny5)
        KennyArray.append(Kenny6)
        KennyArray.append(Kenny7)
        KennyArray.append(Kenny8)
        KennyArray.append(Kenny9)
        
        hideKenny()
        
        //hidekenny timer
   
        hidetime = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(ViewController.hideKenny), userInfo: nil, repeats: true)
        
        
    }
    @objc func hideKenny()
    {
        for kenny in KennyArray
        {
            kenny.isHidden = true //Bütün kennyler görünmez oldu
            
        }
        let random = Int(arc4random_uniform(UInt32(KennyArray.count-1))) // 0 la 8 arası random sayı çıkıcak
        KennyArray[random].isHidden = false

    }
    
    @objc func increaseScore()
    {
        score = score + 1
        ScoreLabel.text = "Score: \(score)"
    }
    
    @objc func timerFunction() //Count down
    {
        counter = counter - 1
        TimeLabel.text = String(counter)
        
        if counter == 0
        {
            timer.invalidate()
            hidetime.invalidate()
            
            if self.score > Int(HighScoreLabel.text!)! //yeni skor highscore dan büyük mü
            {
                UserDefaults.standard.set(self.score, forKey: "Highscore")
                HighScoreLabel.text = String(self.score)
                UserDefaults.standard.synchronize()
            }
            
            
            for kenny in KennyArray
            {
                kenny.isHidden = true //Bütün kennyler görünmez oldu
                
            }
            
            
            let alert =  UIAlertController(title: "Hey!", message: "Time's Off", preferredStyle: UIAlertControllerStyle.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            let replayButton = UIAlertAction(title: "Replay", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
               //önce her şeyi sıfırlıyoruz
                self.score = 0
                self.ScoreLabel.text = "Score: \(self.score)"
                self.counter = 30
                self.TimeLabel.text = "\(self.counter)"
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.timerFunction), userInfo: nil, repeats: true)
                self.hidetime = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(ViewController.hideKenny), userInfo: nil, repeats: true)
                
            })
            alert.addAction(replayButton)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
            
            
            
        }
        
    }



}

