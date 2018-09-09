//
//  ResultViewController.swift
//  BullsCows
//
//  Created by Choong Yee Ching on 02/09/2018.
//  Copyright © 2018 Choong Yee Ching. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    var win:Bool?
    var time:Int?
    var answer:[Int]?
    var resultRecord:String?
    
    @IBOutlet weak var resultImage: UIImageView!
    
    @IBOutlet weak var resultLabel: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if win! == true {
            resultImage.image = UIImage(named: "win")
            let bestTime = UserDefaults.standard.integer(forKey: "bestTime")
            resultLabel.text = "Time：" + String(time!/60) + ":" + String(format: "%02d", time!%60) + "\nBest Time：" + String(bestTime/60) + ":" + String(format: "%02d", bestTime%60)
        }
        else {
            resultImage.image = UIImage(named: "lose")
            resultLabel.text = "Correct Answer:\n\(answer![0])\(answer![1])\(answer![2])\(answer![3])"
        }

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
