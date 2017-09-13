//
//  RegisterViewController.swift
//  findme
//
//  Created by ESPRIT on 16/02/2017.
//  Copyright © 2017 esprit. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner

class RegisterViewController: UIViewController,UIImagePickerControllerDelegate,
UINavigationControllerDelegate  {
    let url = "https://findme2017.000webhostapp.com/findme/register.php"
    
    @IBOutlet weak var nameAlertImage: UIImageView!
    @IBOutlet weak var emailAlertImage: UIImageView!
    @IBOutlet weak var phoneAlertImage: UIImageView!
    @IBOutlet weak var pwdAlertImage: UIImageView!
    @IBOutlet weak var confirmPwdAlertImage: UIImageView!
    
    @IBOutlet weak var choosePicture: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var numberTF: UITextField!
    @IBOutlet weak var pwdTF: UITextField!
    @IBOutlet weak var confirmPwdTF: UITextField!
    let picker = UIImagePickerController()
    var img:UIImage? = nil
    
    let urlRegistredImage = "https://findme2017.000webhostapp.com/findme/updateUserImage.php"
    let random = Int(arc4random_uniform(1000))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTF.attributedPlaceholder = NSAttributedString(string: "Enter Your Email", attributes: [NSForegroundColorAttributeName : UIColor("#aaaaaa")])
        pwdTF.attributedPlaceholder = NSAttributedString(string: "Enter Your Password", attributes: [NSForegroundColorAttributeName : UIColor("#aaaaaa")])
        nameTF.attributedPlaceholder = NSAttributedString(string: "Enter Your Name", attributes: [NSForegroundColorAttributeName : UIColor("#aaaaaa")])
        numberTF.attributedPlaceholder = NSAttributedString(string: "Enter your Number", attributes: [NSForegroundColorAttributeName : UIColor("#aaaaaa")])
        confirmPwdTF.attributedPlaceholder = NSAttributedString(string: "Renter Your Password", attributes: [NSForegroundColorAttributeName : UIColor("#aaaaaa")])
        
        emailTF.layer.cornerRadius = 8
        pwdTF.layer.cornerRadius = 8
        nameTF.layer.cornerRadius = 8
        numberTF.layer.cornerRadius = 8
        confirmPwdTF.layer.cornerRadius = 8
        
        self.nameAlertImage.image = nil
        self.emailAlertImage.image = nil
        self.phoneAlertImage.image = nil
        self.pwdAlertImage.image = nil
        self.confirmPwdAlertImage.image = nil

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage=UIImage()
        self.navigationController?.navigationBar.isTranslucent=true
        self.navigationController?.view.backgroundColor=UIColor.clear
        
        
        
        
        registerBtn.layer.cornerRadius=8
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func chooseImg(_ sender: Any) {
        self.picker.delegate = self
        self.picker.allowsEditing = false
        self.picker.sourceType = .photoLibrary
        self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        self.present(self.picker, animated: true, completion: nil)
    }
    @IBAction func RegisterAction(_ sender: UIButton) {
        if Reachability.isConnectedToNetwork() == true {
            let regex = "[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?"
            let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
            if (nameTF.text == "") {
                initializeAlert(i1: phoneAlertImage,i2: pwdAlertImage,i3: confirmPwdAlertImage,i4: emailAlertImage);
                initializeBorder(tf1: numberTF, tf2: pwdTF, tf3: confirmPwdTF, tf4: emailTF)
                nameAlertImage.image = UIImage(named : "PRGVFInvalid")
                changeBorderColor(tf: nameTF)
                
            }
            else if(emailTF.text == "" || predicate.evaluate(with: emailTF.text) == false)
            {
                
                initializeAlert(i1: phoneAlertImage,i2: pwdAlertImage,i3: confirmPwdAlertImage,i4: nameAlertImage);
                initializeBorder(tf1: numberTF, tf2: pwdTF, tf3: confirmPwdTF, tf4: nameTF)
                
                emailAlertImage.image = UIImage(named : "PRGVFInvalid")
                changeBorderColor(tf: emailTF)
            }
            else if(numberTF.text == ""){
                //must change the type to number in storyboard
                
                initializeAlert(i1: emailAlertImage,i2: pwdAlertImage,i3: confirmPwdAlertImage,i4: nameAlertImage);
                initializeBorder(tf1: emailTF, tf2: pwdTF, tf3: confirmPwdTF, tf4: nameTF)
                
                phoneAlertImage.image = UIImage(named : "PRGVFInvalid")
                changeBorderColor(tf: numberTF)
            }
            else if(pwdTF.text == ""){
                initializeAlert(i1: phoneAlertImage,i2: emailAlertImage,i3: confirmPwdAlertImage,i4: nameAlertImage);
                initializeBorder(tf1: numberTF, tf2: emailTF, tf3: confirmPwdTF, tf4: nameTF)
                pwdAlertImage.image = UIImage(named : "PRGVFInvalid")
                changeBorderColor(tf: pwdTF)
            }
            else if(confirmPwdTF.text == "" || confirmPwdTF.text != pwdTF.text){
                initializeAlert(i1: phoneAlertImage,i2: pwdAlertImage,i3: emailAlertImage,i4: nameAlertImage);
                initializeBorder(tf1: numberTF, tf2: pwdTF, tf3: emailTF, tf4: nameTF)
                confirmPwdAlertImage.image = UIImage(named : "PRGVFInvalid")
                changeBorderColor(tf: confirmPwdTF)
            }
            else{
                print(random)
                let name = nameTF.text
                let email=emailTF.text
                let number = numberTF.text
                let password=pwdTF.text
                let param=[
                    "name":name!,
                    "email": email!,
                    "number":number!,
                    "password": password!
                ]
                if (self.img != nil){
                    SwiftSpinner.show("logging in ..")
                    Alamofire.request(url, method: .post, parameters: param).responseJSON{response in
                        if(response.result.isSuccess){
                            if let json=response.result.value{
                                let jsonResult:Dictionary = json as! Dictionary<String,Any>
                                
                                if(jsonResult["error"] as! Bool == true){
                                    SwiftSpinner.hide()
                                    
                                    let DeleteAlertController = UIAlertController(title: "", message: jsonResult["error_msg"] as! String+"", preferredStyle: .alert)
                                    
                                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
                                    
                                    DeleteAlertController .addAction(cancelAction)
                                    
                                    self.present(DeleteAlertController , animated: true, completion: nil)
                                }
                                
                            }
                        }
                        else if(response.result.isFailure){
                            print("failed")
                            SwiftSpinner.hide()
                            
                        }
                    }
                    
                    
                    let data = UIImageJPEGRepresentation(self.img!, 1)!
                    
                    let id = String(self.random).data(using: String.Encoding.utf8)!
                    let email = self.emailTF.text?.data(using: String.Encoding.utf8)!
                    
                    
                    Alamofire.upload(
                        multipartFormData: { multipartFormData in
                            multipartFormData.append(data, withName: "image", fileName: "image.jpg", mimeType: "image/jpg")
                            multipartFormData.append(id, withName: "id")
                            multipartFormData.append(email!, withName: "email")
                    },
                        to: self.urlRegistredImage,
                        
                        encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload.responseJSON { response in
                                    debugPrint(response)
                                    
                                    if response.description == "SUCCESS: \"1\""{
                                        
                                    }
                                    
                                    
                                    
                                    
                                }
                            case .failure(let encodingError):
                                print(encodingError)
                                
                            }
                    }
                        
                        
                    )
                    self.performSegue(withIdentifier: "RegisterToLogin", sender:self)
                    
                    
                }
                else{
                    let DeleteAlertController = UIAlertController(title: "", message: "you need to pick a picture so your friends can find you !", preferredStyle: .alert)
                    
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
                    
                    DeleteAlertController .addAction(cancelAction)
                    
                    self.present(DeleteAlertController , animated: true, completion: nil)
                }
            }
            SwiftSpinner.hide()
            
            
            
        } else {
            let internetAlertController = UIAlertController(title: "Warning", message: "Please Check Your Internet Connection", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
            internetAlertController.addAction(cancelAction)
            self.present(internetAlertController, animated: true, completion: nil)
            
        }

        
        
        


    }
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
         print("you have picked an image")
         self.img = image
            dismiss(animated: true, completion: nil)
            
        } else{
            print("Something went wrong")
        }
        //imageToPost.contentMode = .scaleAspectFit //3
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func initializeAlert(i1:UIImageView,i2:UIImageView,i3:UIImageView,i4:UIImageView){
        i1.image = nil
        i2.image = nil
        i3.image = nil
        i4.image = nil
    }
    func initializeBorder(tf1:UITextField,tf2:UITextField,tf3:UITextField,tf4:UITextField) {
        
        tf1.layer.borderWidth = 0.0
        tf2.layer.borderWidth = 0.0
        tf3.layer.borderWidth = 0.0
        tf4.layer.borderWidth = 0.0
        
    }
    func changeBorderColor(tf : UITextField)  {
        //tf border color
        let myColor : UIColor = UIColor.red
        tf.layer.borderColor = myColor.cgColor
        tf.layer.borderWidth = 1.0
        
    }
    
   
    
}
