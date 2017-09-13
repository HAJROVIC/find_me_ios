//
//  InformationsViewController.swift
//  findme
//
//  Created by findme on 14/03/2017.
//  Copyright © 2017 esprit. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SwiftSpinner
import CoreData



class InformationsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var infoTable: UITableView!
    //let labels = ["Fullname :","Email :","Phone :","Password :"]
    let labels = ["profileUser","profileMail","profilePhone","profilePass"]
    var infos = [String] ()
    let url = "https://findme2017.000webhostapp.com/findme/users/editInfos.php"
    let url1 = "https://findme2017.000webhostapp.com/findme/users/editpass.php"
    let picker = UIImagePickerController()
    let urlUpdateImage = "https://findme2017.000webhostapp.com/findme/updateUserImage.php"
    let email = SharedPref.sharedpref.prefs.string(forKey: "email")! as String
    let id = SharedPref.sharedpref.prefs.string(forKey: "id")! as String

    var people:[NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        
        
        do {
            people = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        infos.append(people[0].value(forKey: "name") as! String)
        infos.append(people[0].value(forKey: "email") as! String)
        infos.append(String(describing: people[0].value(forKey: "phone") as! NSNumber))
        infos.append(SharedPref.sharedpref.prefs.string(forKey: "password")! as String)
        
        profilePicture.layer.cornerRadius = profilePicture.frame.size.width/2
        profilePicture.clipsToBounds = true
        /*let url2 = URL(string: SharedPref.sharedpref.prefs.string(forKey: "picture")! as String)
        profilePicture.sd_setImage(with: url2, placeholderImage: nil, options: [SDWebImageOptions.continueInBackground, SDWebImageOptions.lowPriority, SDWebImageOptions.refreshCached, SDWebImageOptions.handleCookies, SDWebImageOptions.retryFailed]) { (image, error, cacheType, url2) in
        }*/
        
        if let imageUrl = URL(string: SharedPref.sharedpref.prefs.string(forKey: "picture")! as String) , let placeholder = UIImage(named: "person-placeholder"){
            profilePicture.setImage(withUrl: imageUrl , placeholder: placeholder)
        }
        
        

        
    }
    @IBAction func Cancel(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    @IBAction func ChangeProfile(_ sender: Any) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    @IBAction func Done(_ sender: UIBarButtonItem) {
        
        let doneAlertController = UIAlertController(title: "confirmation", message: "Please enter your password :", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            if doneAlertController.textFields![0].text == SharedPref.sharedpref.prefs.string(forKey: "password")! as String{
             
                var index = IndexPath(row : 0 ,section : 0)
                index.row=0
                var Txt = self.infoTable.cellForRow(at: index)?.contentView.viewWithTag(2002) as! UITextField
                let name = Txt.text
                index.row=1
                Txt = self.infoTable.cellForRow(at: index)?.contentView.viewWithTag(2002) as! UITextField
                let email=Txt.text
                index.row=2
                Txt = self.infoTable.cellForRow(at: index)?.contentView.viewWithTag(2002) as! UITextField
                let number = Txt.text
                index.row=3
                Txt = self.infoTable.cellForRow(at: index)?.contentView.viewWithTag(2002) as! UITextField
                let password=Txt.text
                let id=SharedPref.sharedpref.prefs.string(forKey: "id")
                let param=[
                    "name":name!,
                    "email": email!,
                    "phone":number!,
                    "id": id!
                ]
                Alamofire.request(self.url, method: .post, parameters: param).responseJSON{response in
                    if(response.result.isSuccess){
                        if response.result.value != nil{
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                    else if(response.result.isFailure){
                        print("failed1")
                    }
                }
                let param1=[
                    "password":password!,
                    "id": id!
                ]
                Alamofire.request(self.url1, method: .post, parameters: param1).responseJSON{response in
                    if(response.result.isSuccess){
                        if response.result.value != nil{
                            self.dismiss(animated: true, completion: nil)
                            print("success")
                        }
                    }
                    else if(response.result.isFailure){
                        print("failed2")
                    }
                }
                
                SharedPref.sharedpref.setSharedprefs(email:email!,
                                                     id:Int(id!)!,
                                                     fullName : name!,
                                                     picture :SharedPref.sharedpref.prefs.string(forKey: "picture")! as String,
                                                     password : password!,
                                                     phone: Int(number!)!,
                                                     position:SharedPref.sharedpref.prefs.string(forKey: "position")! as String,
                                                     isLogged:1)

                
            } else {
                // user did not fill field
                print("no hello")
                let errorAlertController = UIAlertController(title: "Error", message: "Wrong Password!", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
                errorAlertController.addAction(cancelAction)
                self.present(errorAlertController, animated: true, completion: nil)

            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        doneAlertController.addTextField { (textField) in
            textField.placeholder = "password"
            textField.isSecureTextEntry = true
        }
        
        doneAlertController.addAction(confirmAction)
        doneAlertController.addAction(cancelAction)
        
        self.present(doneAlertController, animated: true, completion: nil)
            }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 4
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "infoCell")!
        let img = cell.contentView.viewWithTag(2001) as! UIImageView
        img.image = UIImage(named: labels[indexPath.row])
        let txt = cell.contentView.viewWithTag(2002) as! UITextField
        txt.text=infos[indexPath.row]
        
        if indexPath.row == 3 {
            let txt2 = cell.contentView.viewWithTag(2002) as! UITextField
            txt2.isSecureTextEntry = true
        }
        return cell
        
    }
    
    
    public func numberOfSections(in tableView: UITableView) -> Int{
        return 1
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*@IBAction func SaveInfo(_ sender: Any) {
        var index = IndexPath(row : 0 ,section : 0)
        index.row=0
        var Txt = infoTable.cellForRow(at: index)?.contentView.viewWithTag(2002) as! UITextField
        let name = Txt.text
        index.row=1
        Txt = infoTable.cellForRow(at: index)?.contentView.viewWithTag(2002) as! UITextField
        let email=Txt.text
        index.row=2
        Txt = infoTable.cellForRow(at: index)?.contentView.viewWithTag(2002) as! UITextField
        let number = Txt.text
        index.row=3
        Txt = infoTable.cellForRow(at: index)?.contentView.viewWithTag(2002) as! UITextField
        let password=Txt.text
        let id=SharedPref.sharedpref.prefs.string(forKey: "id")
        let param=[
            "name":name!,
            "email": email!,
            "phone":number!,
            "id": id!
        ]
        Alamofire.request(url, method: .post, parameters: param).responseJSON{response in
            if(response.result.isSuccess){
                if response.result.value != nil{
                    self.dismiss(animated: true, completion: nil)
                }
            }
            else if(response.result.isFailure){
                print("failed1")
            }
        }
        let param1=[
            "password":password!,
            "id": id!
        ]
        Alamofire.request(url1, method: .post, parameters: param1).responseJSON{response in
            if(response.result.isSuccess){
                if response.result.value != nil{
                    self.dismiss(animated: true, completion: nil)
                    print("success")
                }
            }
            else if(response.result.isFailure){
                print("failed2")
            }
        }
        
        SharedPref.sharedpref.setSharedprefs(email:email!,
                                             id:Int(id!)!,
                                             fullName : name!,
                                             picture :SharedPref.sharedpref.prefs.string(forKey: "picture")! as String,
                                             password : password!,
                                             phone: Int(number!)!,
                                             position:SharedPref.sharedpref.prefs.string(forKey: "position")! as String,
                                             isLogged:1)


    }*/
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        if let imageFromGallery = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profilePicture.image = imageFromGallery
        } else{
            print("Something went wrong")
        }
        profilePicture.layer.cornerRadius = profilePicture.frame.size.width/2
        profilePicture.clipsToBounds = true
        self.dismiss(animated: true, completion: nil)
        SwiftSpinner.show("Updating your photo...")
        if (self.profilePicture.image != nil){
            
            //SwiftSpinner.show("Uploading Picutre...")
            let data = UIImageJPEGRepresentation(self.profilePicture.image!, 1)!
            let id = self.id.data(using: String.Encoding.utf8)!
            let email = self.email.data(using: String.Encoding.utf8)!
            
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    multipartFormData.append(data, withName: "image", fileName: "image.jpg", mimeType: "image/jpg")
                    multipartFormData.append(id, withName: "id")
                    multipartFormData.append(email, withName: "email")
                    
            },
                to: self.urlUpdateImage,
                
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            debugPrint(response)
                            //  SwiftSpinner.hide()
                            if response.description == "SUCCESS: \"1\""{
                                //   CDAlertView(title: "Upload", message: "Image Sucessfully Uploaded !", type: .success).show()
                            }else{
                                //  CDAlertView(title: "Upload", message: "Upload Image Failed !", type: .error).show()
                            }
                            
                            
                            
                            
                            
                        }
                    case .failure(let encodingError):
                        print(encodingError)
                        
                        //  SwiftSpinner.hide()
                    }
            }
                
                
            )
        }
        SwiftSpinner.hide()
        dismiss(animated: true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

}
