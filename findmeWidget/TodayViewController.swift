//
//  TodayViewController.swift
//  findmeWidget
//
//  Created by findme on 08/05/2017.
//  Copyright © 2017 esprit. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet weak var img: UIButton!
    @IBOutlet weak var lbl: UILabel!
        
    @IBAction func launchApp(_ sender: Any) {
        self.extensionContext?.open(URL(string:"findme://")!, completionHandler:{(success)  in
            if (!success) {
                print("task erreur!")
            }
            else {
                print("task done!")
                
            }
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        img.layer.cornerRadius = 10
        
        
 
        if(UserDefaults.init(suiteName: "group.com.esprit.findme")?.value(forKey: "name") != nil){
            var val: String!
            val = UserDefaults.init(suiteName: "group.com.esprit.findme")?.value(forKey: "name") as! String!
            let txt = "Hello Dear "+val
            var myMutableString = NSMutableAttributedString()
            myMutableString = NSMutableAttributedString(string: txt, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 18.0)!])
            myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: NSRange(location:0,length:11))

            
        lbl.attributedText = myMutableString
        }
              // Do any additional setup after loading the view from its nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
