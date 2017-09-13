//
//  MyTabViewController.swift
//  findme
//
//  Created by findme on 17/04/2017.
//  Copyright © 2017 esprit. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift

class MyTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tabBar.unselectedItemTintColor = UIColor("#aaa")
        self.tabBar.barTintColor = UIColor("#fff")
        self.tabBar.layer.borderWidth = 0.50
        self.tabBar.layer.borderColor = UIColor("#dfdfdf").cgColor
        self.tabBar.clipsToBounds = true
    
        
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
/*extension UITabBar{
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 20
        return sizeThatFits
    }

}*/
