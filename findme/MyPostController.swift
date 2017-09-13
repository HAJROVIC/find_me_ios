//
//  MyPostController.swift
//  findme
//
//  Created by ESPRIT on 04/04/2017.
//  Copyright © 2017 esprit. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import MapleBacon

class MyPostController: UIViewController {

    @IBOutlet weak var ProfiePicture: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var content: UILabel!
    let url = "https://findme2017.000webhostapp.com/findme/getNewsById.php"
    let url2 = "https://findme2017.000webhostapp.com/findme/deleteNewsById.php"
    var listNews : [News] =  []
    var id:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let param=[
            "id":id
        ]
        Alamofire.request(url, method: .get, parameters: param).responseJSON{response in
            if(response.result.isSuccess){
                if let json=response.result.value{
                    let jsonResult:Dictionary = json as! Dictionary<String,Any>
                    let jsonNews:NSArray = jsonResult["news"] as! NSArray
                    for i in jsonNews{
                        let n : News = News(dic : i as! [String : Any])
                        self.listNews.append(n)
                    }
                    self.name.text=SharedPref.sharedpref.prefs.string(forKey: "fullname")! as String
                    self.time.text=self.listNews[0].date
                    self.content.text = self.listNews[0].desc
                    self.ProfiePicture.layer.cornerRadius = self.ProfiePicture.frame.size.width/2
                    self.ProfiePicture.clipsToBounds = true
                    /*let url2 = URL(string: self.listNews[0].picture)
                    self.ProfiePicture.sd_setImage(with: url2, placeholderImage: nil, options: [SDWebImageOptions.continueInBackground, SDWebImageOptions.lowPriority, SDWebImageOptions.refreshCached, SDWebImageOptions.handleCookies, SDWebImageOptions.retryFailed]) { (image, error, cacheType, url2) in
                    }*/
                    if let imageUrl = URL(string:  self.listNews[0].picture) , let placeholder = UIImage(named: "person-placeholder"){
                        self.ProfiePicture.setImage(withUrl: imageUrl , placeholder: placeholder)
                    }
                    

                    /*let url = URL(string: self.listNews[0].url)
                    self.image.sd_setImage(with: url, placeholderImage: nil, options: [SDWebImageOptions.continueInBackground, SDWebImageOptions.lowPriority, SDWebImageOptions.refreshCached, SDWebImageOptions.handleCookies, SDWebImageOptions.retryFailed]) { (image, error, cacheType, url) in
                    }*/
                    if let imageUrl1 = URL(string: self.listNews[0].url) , let placeholder = UIImage(named: "placeholder1"){
                        self.image.setImage(withUrl: imageUrl1 , placeholder: placeholder)
                    }


                    
                }
            }
            else if(response.result.isFailure){
                print("faied22")
            }
        }


        // Do any additional setup after loading the view.
    }
    @IBAction func Cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)

    }

    @IBAction func Delete(_ sender: UIBarButtonItem) {
        
        let DeleteAlertController = UIAlertController(title: "", message: "Did you want really to delete this post ?", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Delete", style: .default) { (_) in
            let param=[
                "id":self.id
            ]
            print(self.id)
            Alamofire.request(self.url2, method: .get, parameters: param).responseJSON{response in
                if(response.result.isSuccess){
                    self.dismiss(animated: true, completion: nil)
                }
                else if(response.result.isFailure){
                    print(response.result.debugDescription)
                }
            }
            self.dismiss(animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        DeleteAlertController .addAction(confirmAction)
        DeleteAlertController .addAction(cancelAction)
        
        self.present(DeleteAlertController , animated: true, completion: nil)


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
