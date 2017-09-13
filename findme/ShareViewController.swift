//
//  ShareViewController.swift
//  findme
//
//  Created by findme on 14/03/2017.
//  Copyright © 2017 esprit. All rights reserved.
//

import UIKit
import Alamofire
import Foundation
import SwiftSpinner

class ShareViewController: UIViewController
{
    
    var server:String="https://findme2017.000webhostapp.com/findme/news/addNews.php"
    var content:String="ahawa l ios"
    var circle_id:String="1"
    var id_user:String="2"
    public var img2 :UIImage = UIImage()

  
    @IBOutlet weak var contentToPost: UITextField!
    @IBOutlet weak var imageToPost: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imageToPost.image = img2
        
    }
    /*@IBAction func photoFromLibrary(_ sender: UIButton) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }*/

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func Upload(_ sender: UIBarButtonItem) {
        SwiftSpinner.show("Sharing...")
        if (self.imageToPost.image != nil){
            
            //SwiftSpinner.show("Uploading Picutre...")
            let data = UIImageJPEGRepresentation(self.imageToPost.image!, 1)!
            let contentParam = self.contentToPost.text!.data(using: String.Encoding.utf8)!
            let circle_idParam = self.circle_id.data(using: String.Encoding.utf8)!
            let id_userParam = self.id_user.data(using: String.Encoding.utf8)!
            
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    multipartFormData.append(data, withName: "image", fileName: "image.jpg", mimeType: "image/jpg")
                    multipartFormData.append(circle_idParam, withName: "circle_id")
                    multipartFormData.append(id_userParam, withName: "id_user")
                    multipartFormData.append(contentParam, withName: "content")
            },
                to: self.server,
                
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
                                            }
            }
                
                
            )
        }
        SwiftSpinner.hide()
        dismiss(animated: true, completion: nil)
    }
    
   /* @IBAction func uploadAction(_ sender: UIButton) {
        SwiftSpinner.show("Sharing...")
        if (self.imageToPost.image != nil){
            
            //SwiftSpinner.show("Uploading Picutre...")
            let data = UIImageJPEGRepresentation(self.imageToPost.image!, 1)!
            let contentParam = self.contentToPost.text!.data(using: String.Encoding.utf8)!
            let circle_idParam = self.circle_id.data(using: String.Encoding.utf8)!
            let id_userParam = self.id_user.data(using: String.Encoding.utf8)!
            
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    multipartFormData.append(data, withName: "image", fileName: "image.jpg", mimeType: "image/jpg")
                    multipartFormData.append(circle_idParam, withName: "circle_id")
                    multipartFormData.append(id_userParam, withName: "id_user")
                    multipartFormData.append(contentParam, withName: "content")
            },
                to: self.server,
                
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
    }*/
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
