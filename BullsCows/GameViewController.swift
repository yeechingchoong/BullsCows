//
//  GameViewController.swift
//  BullsCows
//
//  Created by Choong Yee Ching on 02/09/2018.
//  Copyright © 2018 Choong Yee Ching. All rights reserved.
//

import UIKit
import GameplayKit

class GameViewController: UIViewController {

    var answer = [0,0,0,0]
    var input:[Int] = []
    var chance = 10
    var totalTime = 0
    var timer = Timer()
    var over = false
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var chanceLabel: UILabel!
    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var resultRecord: UITextView!
    @IBOutlet var numberButtons: [UIButton]!
    
    
    //設定時間
    func timerStart(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initial()
        timerStart()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if over == true {
            over = false
            initial()
        }
    }
    
    @objc func updateTime(){
        totalTime += 1
        timeLabel.text = String(totalTime/60) + ":" + String(format: "%02d", totalTime%60)
    }
    
    //設定遊戲規則
    func initial(){
        var nums = Array(0...9)
        for i in 0...3 {
            let index = Int(arc4random_uniform(UInt32(nums.count)))
            answer[i] = nums[index]
            nums.remove(at: index)
        }
        while !input.isEmpty {
            let letter = input.popLast()
            numberButtons[letter!].isEnabled = true
            let index = inputLabel.text?.index(inputLabel.text!.startIndex, offsetBy: input.count*3)
            inputLabel.text?.remove(at: index!)
            inputLabel.text?.insert("＿", at: index!)
        }
    }
    
    
    @IBAction func pressButton(_ sender: UIButton) {
        //輸入數字未超過四個，輸入過的數字鍵，停止功能
      if input.count < 4 {
            sender.isEnabled = true
            sender.setTitleColor(UIColor.gray, for: .normal)
            let index = inputLabel.text?.index(inputLabel.text!.startIndex, offsetBy: input.count*3)
        inputLabel.text?.remove(at: index!)
            inputLabel.text?.insert(Character(sender.title(for: .normal)!), at: index!)
            input.append(Int(sender.title(for: .normal)!)!)
      }
    }
    
    @IBAction func deleteNumber(_ sender: Any) {
        if !input.isEmpty {
            let letter = input.popLast()
            numberButtons[letter!].isEnabled = true
            numberButtons[letter!].setTitleColor(UIColor.black, for: .normal)
            let index = inputLabel.text?.index(inputLabel.text!.startIndex, offsetBy: input.count*3)
            inputLabel.text?.remove(at: index!)
            inputLabel.text?.insert("＿", at: index!)
        }
    }
    
    
    func addRecord(win:Bool, time:Int){
        let userDefault = UserDefaults.standard
        var gameCount = userDefault.integer(forKey: "gameCount")
        gameCount += 1
        userDefault.set(gameCount, forKey: "gameCount")
        if win == true {
            var winCount = userDefault.integer(forKey: "winCount")
            var totalTime = userDefault.integer(forKey: "totalTime")
            var bestTime = userDefault.integer(forKey: "bestTime")
            winCount += 1
            totalTime += time
            if bestTime == 0 || time < bestTime {
                bestTime = time
            }
            userDefault.set(winCount, forKey: "winCount")
            userDefault.set(totalTime, forKey: "totalTime")
            userDefault.set(bestTime, forKey: "bestTime")
        }
        userDefault.synchronize()
    }
    
    
    @IBAction func send(_ sender: Any) {
        if input.count != 4 {
            let optionMenu = UIAlertController(title: nil, message: "Please insert 4 differnt digits", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Comfirm", style: .cancel, handler: nil)
            optionMenu.addAction(cancelAction)
            present(optionMenu, animated: true, completion: nil)
        }
        else {
            var acount = 0
            var bcount = 0
            for i in 0...3 {
                for j in 0...3 {
                    if answer[i] == input[j] {
                        if i == j {
                            acount += 1
                        }
                        else {
                            bcount += 1
                        }
                        break
                    }
                }
            }
            resultRecord.text! += "\(input[0])\(input[1])\(input[2])\(input[3])\t\t\(acount)\t\t\t\(bcount)\n"
            resultRecord.font = UIFont.systemFont(ofSize: 25)
            resultRecord.scrollRangeToVisible(NSMakeRange(resultRecord.text.characters.count-1, 0))
            while !input.isEmpty {
                let letter = input.popLast()
                numberButtons[letter!].isEnabled = true
                numberButtons[letter!].setTitleColor(UIColor.black, for: .normal)
                let index = inputLabel.text?.index(inputLabel.text!.startIndex, offsetBy: input.count*3)
                inputLabel.text?.remove(at: index!)
                inputLabel.text?.insert("＿", at: index!)
            }
            if acount != 4 {
                chance -= 1
                chanceLabel.text = "\(chance)"
                if chance == 0 {
                    timer.invalidate()
                    over = true
                    addRecord(win: false, time: totalTime)
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController
                    controller.win = false
                    controller.time = totalTime
                    controller.answer = self.answer
                    self.present(controller, animated: false, completion: nil)
                }
            }
            else {
                timer.invalidate()
                over = true
                addRecord(win: true, time: totalTime)
                //轉移至其他ViewController
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController
                controller.win = true
                controller.time = totalTime
                self.present(controller, animated: false, completion: nil)
            }
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


