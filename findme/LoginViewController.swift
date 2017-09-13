//
//  LoginViewController.swift
//  findme
//
//  Created by ESPRIT on 16/02/2017.
//  Copyright © 2017 esprit. All rights reserved.
//

import UIKit
import Alamofire
import  CoreData
import UIColor_Hex_Swift
import FBSDKLoginKit
import FBSDKCoreKit
import SwiftSpinner


var x: Int?

class LoginViewController: UIViewController {

    
    
    let loginManager = FBSDKLoginManager()
    var fbData = [String: AnyObject]()
    var twiData = [String: AnyObject]()
    var lnData = [String: AnyObject]()
    var gData = [String: AnyObject]()
    var image: String?
    var name: String?
    var email: String?
    
    @IBOutlet weak var signin: UIButton!
    @IBOutlet weak var fbLogin: UIButton!
    
    let url = "https://findme2017.000webhostapp.com/findme/login.php"
    let url1 = "https://findme2017.000webhostapp.com/findme/loginFacebook.php"
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTF.attributedPlaceholder = NSAttributedString(string: "Enter Your Email", attributes: [NSForegroundColorAttributeName : UIColor("#aaaaaa")])
        passwordTF.attributedPlaceholder = NSAttributedString(string: "Enter Your Password", attributes: [NSForegroundColorAttributeName : UIColor("#aaaaaa")])
        
        emailTF.layer.cornerRadius = 8
        passwordTF.layer.cornerRadius = 8
        

        
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage=UIImage()
        self.navigationController?.navigationBar.isTranslucent=true
        self.navigationController?.view.backgroundColor=UIColor.clear
        
        signin.layer.cornerRadius=8
        fbLogin.layer.cornerRadius=8
        
        //self.navigationController?.navigationBar.backItem?.hidesBackButton=
        

        // Do any additional setup after loading the view.
        
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage=UIImage()
        self.navigationController?.navigationBar.isTranslucent=true
        self.navigationController?.view.backgroundColor=UIColor.clear
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
                
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginFB(_ sender: UIButton) {
        if Reachability.isConnectedToNetwork() == true {
            
            x = 1
            loginManager.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: self) { (result, error) in
                
                if error != nil
                {
                    print("error occured with login \(error?.localizedDescription)")
                }
                    
                else if (result?.isCancelled)!
                {
                    print("login canceled")
                }
                    
                else
                {
                    if FBSDKAccessToken.current() != nil
                    {
                        
                        FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":"id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, userResult, error) in
                            
                            
                            if error != nil
                            {
                                print("error occured \(error?.localizedDescription)")
                            }
                            else if userResult != nil
                            {
                                print("Login with FB is success!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
                                SwiftSpinner.show("logging in ...")
                                let dic = userResult as? NSDictionary
                                
                                
                                let email = dic?.object(forKey: "email") as! String
                                let password = dic?.object(forKey: "id") as! String
                                let name = dic?.object(forKey: "name") as! String
                                let photo = (((dic?.object(forKey:"picture") as! NSDictionary).object(forKey: "data") as! NSDictionary).object(forKey: "url") as? String)!
                                
                                let param1=[
                                    "email": email,
                                    "name": name,
                                    "photo": photo,
                                    "password": password
                                ]
                                
                                Alamofire.request(self.url1, method: .post, parameters: param1).responseJSON{response in
                                    if(response.result.isSuccess){
                                        if let json=response.result.value{
                                            let jsonResult:Dictionary = json as! Dictionary<String,Any>
                                            if(jsonResult["error"] as! Bool == false){
                                                
                                                let details:Dictionary = jsonResult["user"] as! Dictionary<String,Any>
                                                
                                                SharedPref.sharedpref.setSharedprefs(email:details["email"] as! String,
                                                                                     id:details["id"] as! Int,
                                                                                     fullName : details["name"] as! String,
                                                                                     picture :details["photo"] as! String,
                                                                                     password : password,
                                                                                     phone: 0 ,
                                                                                     position : " ",
                                                                                     isLogged:1)
                                                SharedPref.sharedpref.setCircleIndex(index: 0000)
                                                UserDefaults.init(suiteName: "group.com.esprit.findme")?.setValue(details["name"] as! String , forKey: "name")
                                                let appdelegate = UIApplication.shared.delegate as! AppDelegate
                                                
                                                let managedContext  =  appdelegate.persistentContainer.viewContext
                                                
                                                let newPerson = NSEntityDescription.insertNewObject(forEntityName: "User", into: managedContext)
                                                
                                                newPerson.setValue(details["name"] as! String, forKey: "name")
                                                newPerson.setValue(details["email"] as! String, forKey: "email")
                                                newPerson.setValue(details["phone"] as! Int, forKey: "phone")
                                                newPerson.setValue(details["photo"] as! String, forKey: "photo")
                                                newPerson.setValue(details["id"] as! Int, forKey: "id")
                                                
                                                do{
                                                    try managedContext.save()
                                                    print("bravo")
                                                    
                                                    
                                                }catch{
                                                    print("there was an error")
                                                }
                                                SwiftSpinner.hide()
                                                self.performSegue(withIdentifier: "loginSegue", sender:self)
                                            }
                                            else{
                                                SwiftSpinner.hide()
                                                print(jsonResult["error_msg"] as! String)
                                                
                                            }
                                        }
                                    }
                                    else if(response.result.isFailure){
                                        SwiftSpinner.hide()
                                        print("failed")
                                    }
                                }
                                
                            }
                            
                        })
                    }
                    
                }
                
            }

            
        } else {
            let internetAlertController = UIAlertController(title: "Warning", message: "Please Check Your Internet Connection", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
            internetAlertController.addAction(cancelAction)
            self.present(internetAlertController, animated: true, completion: nil)
            
        }

        
  
    }
    @IBAction func LoginButton(_ sender: Any) {
        if Reachability.isConnectedToNetwork() == true {
            let email=emailTF.text
            let password=passwordTF.text
            if(email != "" || password != ""){
                SwiftSpinner.show("Logging in...")
                let param=[
                    "email": email!,
                    "password": password!
                ]
                
                Alamofire.request(url, method: .post, parameters: param).responseJSON{response in
                    if(response.result.isSuccess){
                        if let json=response.result.value{
                            let jsonResult:Dictionary = json as! Dictionary<String,Any>
                            if(jsonResult["error"] as! Bool == false){
                                
                                let details:Dictionary = jsonResult["user"] as! Dictionary<String,Any>
                                
                                SharedPref.sharedpref.setSharedprefs(email:details["email"] as! String,
                                                                     id:details["id"] as! Int,
                                                                     fullName : details["name"] as! String,
                                                                     picture :details["photo"] as! String,
                                                                     password : password!,
                                                                     phone: details["phone"] as! Int,
                                                                     position : " ",
                                                                     isLogged:1)
                                UserDefaults.init(suiteName: "group.com.esprit.findme")?.setValue(details["name"] as! String , forKey: "name")
                                let appdelegate = UIApplication.shared.delegate as! AppDelegate
                                
                                let managedContext  =  appdelegate.persistentContainer.viewContext
                                
                                let newPerson = NSEntityDescription.insertNewObject(forEntityName: "User", into: managedContext)
                                
                                newPerson.setValue(details["name"] as! String, forKey: "name")
                                newPerson.setValue(details["email"] as! String, forKey: "email")
                                newPerson.setValue(details["phone"] as! Int, forKey: "phone")
                                newPerson.setValue(details["photo"] as! String, forKey: "photo")
                                newPerson.setValue(details["id"] as! Int, forKey: "id")
                                
                                do{
                                    try managedContext.save()
                                    print("bravo")
                                
                                    
                                }catch{
                                    print("there was an error")
                                }
                                
                                SwiftSpinner.hide()
                                self.performSegue(withIdentifier: "loginSegue", sender:self)
                                
                            }
                            else{
                                SwiftSpinner.hide()
                                print(jsonResult["error_msg"] as! String)
                                let AlertController = UIAlertController(title: "", message: "Please verify your credentials!", preferredStyle: .alert)
                                
                                
                                
                                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
                                
                                
                                
                                
                                AlertController.addAction(cancelAction)
                                
                                self.present(AlertController, animated: true, completion: nil)
                                
                                
                            }
                        }
                    }
                    else if(response.result.isFailure){
                        print("failed")
                    }
                }
            }else{
                let AlertController = UIAlertController(title: "", message: "Please enter your credentials!", preferredStyle: .alert)
                
                
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
                
                
                
                
                AlertController.addAction(cancelAction)
                
                self.present(AlertController, animated: true, completion: nil)
                
            }

            
        } else {
            let internetAlertController = UIAlertController(title: "Warning", message: "Please Check Your Internet Connection", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
            internetAlertController.addAction(cancelAction)
            self.present(internetAlertController, animated: true, completion: nil)
            
        }

        

        
    }

}
