//
//  FirstViewController.swift
//  findme
//
//  Created by findme on 07/03/2017.
//  Copyright © 2017 esprit. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var signIn: UIButton!
    @IBOutlet weak var register: UIButton!
    @IBOutlet weak var back: UIImageView!
    @IBOutlet weak var titre1: UILabel!
    @IBOutlet weak var titre2: UILabel!
 
    override func viewDidLoad() {
        super.viewDidLoad()
       
        signIn.layer.cornerRadius = 8
        register.layer.cornerRadius = 8
        register.isHidden = true
        signIn.isHidden = true
        back.isHidden = true
        titre1.isHidden = true
        titre2.isHidden = true
        
        
        UINavigationBar.appearance().tintColor=UIColor.white
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            self.navigationController?.setNavigationBarHidden(true, animated: animated)
            if SharedPref.sharedpref.prefs.integer(forKey: "ISLOGGEDIN") == 1 {
                let view = self.storyboard? .instantiateViewController(withIdentifier: "home")
                DispatchQueue.main.async {
                    self.navigationController?.present(view!, animated: true, completion: nil)
                }
            }
            else{
                register.isHidden = false
                signIn.isHidden = false
                back.isHidden = false
                titre1.isHidden = false
                titre2.isHidden = false
                
            }
        } else {
            let internetAlertController = UIAlertController(title: "Warning", message: "Please Check Your Internet Connection", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
            internetAlertController.addAction(cancelAction)
            self.present(internetAlertController, animated: true, completion: nil)
            register.isHidden = false
            signIn.isHidden = false
            back.isHidden = false
            titre1.isHidden = false
            titre2.isHidden = false
            self.navigationController?.setNavigationBarHidden(true, animated: animated)

        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
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
