//
//  NewsViewController.swift
//  findme
//
//  Created by ESPRIT on 07/03/2017.
//  Copyright © 2017 esprit. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import MessageUI
import MapleBacon
import SystemConfiguration
import CoreData

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,MFMessageComposeViewControllerDelegate,
    UIImagePickerControllerDelegate,
UINavigationControllerDelegate  {
    
    
    @IBOutlet weak var tableView: UITableView!
    let url = "https://findme2017.000webhostapp.com/findme/news/getAllCircleNews.php"
    let urlCreationCircle = "https://findme2017.000webhostapp.com/findme/circle.php"
    let urlJoinCircle = "https://findme2017.000webhostapp.com/findme/inviter.php"
    var listNews : [News] =  []
    let urlGetCircles = "https://findme2017.000webhostapp.com/findme/news/testCircles.php"
    var listCircles : [Circle] =  []
    var names = [String]()
    var idTab = [String]()
    let notificationName = Notification.Name("NotificationIdentifier")
    let picker = UIImagePickerController()
    var img:UIImage = UIImage()
    var people:[NSManagedObject] = []
    var cnt = 0


    @IBOutlet weak var drop: HADropDown!
    
  
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
    }
    
  
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
  
        
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.reload(notif:)), name: notificationName, object: nil)
        IJProgressView.shared.showProgressView(view)
        let id : String = SharedPref.sharedpref.prefs.string(forKey: "id")!
        let param1=[
            "user_id": id
        ]
        if Reachability.isConnectedToNetwork() == true {
            Alamofire.request(urlGetCircles, method: .get, parameters: param1).responseJSON{response in
                if(response.result.isSuccess){
                    if let json=response.result.value{
                        let jsonResult1:Dictionary = json as! Dictionary<String,Any>
                        let jsonNews:NSArray = jsonResult1["circles"] as! NSArray
                        
                        for i in jsonNews{
                            let n : Circle = Circle(dic : i as! [String : Any])
                            self.listCircles.append(n)
                            self.names.append(n.name)
                            self.idTab.append(n.id)
                            self.drop.items = self.names
                        }
                        SharedPref.sharedpref.setCircleIndex(index: 0000)
                        
                        if (SharedPref.sharedpref.prefs.string(forKey: "circle_index")!) != "0000"{
                            
                            
                            SharedPref.sharedpref.setCircleSharedPref(id:Int(self.idTab[Int(SharedPref.sharedpref.prefs.string(forKey: "circle_index")!)!])!,code:self.listCircles[Int(SharedPref.sharedpref.prefs.string(forKey: "circle_index")!)!].code)
                            
                            
                            self.drop.title=self.names[Int(SharedPref.sharedpref.prefs.string(forKey: "circle_index")!)!]
                            let param=[
                                "circle_id": self.idTab[Int(SharedPref.sharedpref.prefs.string(forKey: "circle_index")!)!]
                                
                            ]
                            Alamofire.request(self.url, method: .get, parameters: param).responseJSON{response in
                                if(response.result.isSuccess){
                                    if let json=response.result.value{
                                        let jsonResult:Dictionary = json as! Dictionary<String,Any>
                                        let jsonNews:NSArray = jsonResult["news"] as! NSArray
                                        for i in jsonNews{
                                            let n : News = News(dic : i as! [String : Any])
                                            self.listNews.append(n)
                                        }
                                        self.tableView.reloadData()
                                        IJProgressView.shared.hideProgressView()
                                        
                                    }
                                }
                                else if(response.result.isFailure){
                                    print("failed news")
                                    IJProgressView.shared.hideProgressView()
                                }
                            }
                            
                        }else{
                            self.drop.title=self.names[0]
                        }
                        
                        
                    }
                }
                else if(response.result.isFailure){
                    print("failed circles")
                    IJProgressView.shared.hideProgressView()
                }
            }
        }
        
        else {
            let internetAlertController = UIAlertController(title: "Warning", message: "Please Check Your Internet Connection", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
            internetAlertController.addAction(cancelAction)
            self.present(internetAlertController, animated: true, completion: nil)
            
        }
        tableView.backgroundColor=UIColor("#DFDFDF")
        self.navigationController?.navigationBar.isHidden=true
        //UINavigationBar.appearance().backgroundColor=UIColor("#aaaaaa")
    }
    func reload(notif : Notification){

        SharedPref.sharedpref.setCircleSharedPref(id:Int(self.idTab[Int(SharedPref.sharedpref.prefs.string(forKey: "circle_index")!)!])!,code:self.listCircles[Int(SharedPref.sharedpref.prefs.string(forKey: "circle_index")!)!].code)
        
        let circleId:String = idTab[Int(SharedPref.sharedpref.prefs.string(forKey: "circle_index")!)!]
                let param=[
            "circle_id":circleId
            
        ]
        if Reachability.isConnectedToNetwork() == true {
            IJProgressView.shared.showProgressView(view)
            Alamofire.request(url, method: .get, parameters: param).responseJSON{response in
                if(response.result.isSuccess){
                    if let json=response.result.value{
                        let jsonResult:Dictionary = json as! Dictionary<String,Any>
                        let jsonNews:NSArray = jsonResult["news"] as! NSArray
                        self.listNews.removeAll()
                        for i in jsonNews{
                            let n : News = News(dic : i as! [String : Any])
                            self.listNews.append(n)
                            
                        }
                        self.tableView.reloadData()
                        IJProgressView.shared.hideProgressView()

                    }
                }
                else if(response.result.isFailure){
                    print("failed news")
                    IJProgressView.shared.hideProgressView()

                }
            }

        }
        
        else {
            let internetAlertController = UIAlertController(title: "Warning", message: "Please Check Your Internet Connection", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
            internetAlertController.addAction(cancelAction)
            self.present(internetAlertController, animated: true, completion: nil)
            
        }

    }

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        let v = cell.contentView.viewWithTag(1000)
        v?.layer.cornerRadius = 12
        let lbl1 = cell.contentView.viewWithTag(11) as! UILabel
        lbl1.text = listNews[indexPath.section].name
        let lbl2 = cell.contentView.viewWithTag(12) as! UILabel
        lbl2.text = listNews[indexPath.section].date
        let lbl4 = cell.contentView.viewWithTag(14) as! UILabel
        lbl4.text = listNews[indexPath.section].desc
        
        let image1 = cell.contentView.viewWithTag(10) as! UIImageView
        image1.layer.cornerRadius = image1.frame.size.width/2
        image1.clipsToBounds = true
        
        if let imageUrl = URL(string: listNews[indexPath.section].picture) , let placeholder = UIImage(named: "person-placeholder"){
            image1.setImage(withUrl: imageUrl , placeholder: placeholder)
        }
      /*  let url = URL(string: listNews[indexPath.section].picture)
        image1.sd_setImage(with: url, placeholderImage: nil, options: [SDWebImageOptions.continueInBackground, SDWebImageOptions.lowPriority, SDWebImageOptions.refreshCached, SDWebImageOptions.handleCookies, SDWebImageOptions.retryFailed]) { (image, error, cacheType, url) in
            
        }*/

        
        
        
        
        let image2 = cell.contentView.viewWithTag(13) as! UIImageView
        
        if let imageUrl1 = URL(string: listNews[indexPath.section].url) , let placeholder = UIImage(named: "placeholder1"){
            image2.setImage(withUrl: imageUrl1 , placeholder: placeholder)
        }
       /* let url1 = URL(string: listNews[indexPath.section].url)
        image2.sd_setImage(with: url1, placeholderImage: nil, options: [SDWebImageOptions.continueInBackground, SDWebImageOptions.lowPriority, SDWebImageOptions.refreshCached, SDWebImageOptions.handleCookies, SDWebImageOptions.retryFailed]) { (image, error, cacheType, url1) in
            
        }*/
        

        
        return cell
        
    }
    
    
    public func numberOfSections(in tableView: UITableView) -> Int{
        return listNews.count
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    @IBAction func more(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "", message: "What would you like to do?", preferredStyle: .actionSheet)
        
        let inviteButton = UIAlertAction(title: "invite your friend", style: .default, handler: { (action) -> Void in
            /*if (MFMessageComposeViewController.canSendText()) {
                let controller = MFMessageComposeViewController()
                controller.body = ""
                controller.recipients = ["21456789"]
                controller.messageComposeDelegate = self
                self.present(controller, animated: true, completion: nil)
            }else{
                print("ghalet")
                
            }*/
            let activityViewController = UIActivityViewController(
                activityItems: ["Check out this beer I liked using Beer Tracker.", "xxx"],
                applicationActivities: nil)
            if let popoverPresentationController = activityViewController.popoverPresentationController {
                popoverPresentationController.barButtonItem = (sender as! UIBarButtonItem)
            }
            self.present(activityViewController, animated: true, completion: nil)
        })
        
        let  joinButton = UIAlertAction(title: "join a circle", style: .default, handler: { (action) -> Void in
            let JoinCirclealertController = UIAlertController(title: "Join A Circle", message: "Please input the circle code:", preferredStyle: .alert)
            
            let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
                
                    // store your data
                    let circle_code = JoinCirclealertController.textFields?[0].text
                    let user_id=SharedPref.sharedpref.prefs.string(forKey: "id")!
                    let param=[
                        "circle_code":circle_code!,
                        "user_id": user_id
                    ]
                    if Reachability.isConnectedToNetwork() == true {
                        Alamofire.request(self.urlJoinCircle, method: .post, parameters: param).responseJSON{response in
                            if(response.result.isSuccess){
                                if let json=response.result.value{
                                    let jsonResult:Dictionary = json as! Dictionary<String,Any>
                                    let id : String = SharedPref.sharedpref.prefs.string(forKey: "id")!
                                    let param1=[
                                        "user_id": id
                                    ]
                                    
                                    Alamofire.request(self.urlGetCircles, method: .get, parameters: param1).responseJSON{response in
                                        if(response.result.isSuccess){
                                            if let json=response.result.value{
                                                let jsonResult1:Dictionary = json as! Dictionary<String,Any>
                                                let jsonNews:NSArray = jsonResult1["circles"] as! NSArray
                                                self.names.removeAll()
                                                for i in jsonNews{
                                                    let n : Circle = Circle(dic : i as! [String : Any])
                                                    self.listCircles.append(n)
                                                    self.names.append(n.name)
                                                    self.idTab.append(n.id)
                                                    self.drop.items = self.names
                                                }
                                                
                                                self.drop.title=self.names[Int(SharedPref.sharedpref.prefs.string(forKey: "circle_index")!)!]
                                            }
                                        }
                                        else if(response.result.isFailure){
                                            print("failed circles")
                                        }
                                    }
                                    
                                    
                                    print(jsonResult["error"] as! Bool)
                                }
                            }
                            else if(response.result.isFailure){
                                print("failed")
                            }
                        }
                    }
                    else {
                        let internetAlertController = UIAlertController(title: "Warning", message: "Please Check Your Internet Connection", preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
                        internetAlertController.addAction(cancelAction)
                        self.present(internetAlertController, animated: true, completion: nil)
                        
                }
                
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
            
            JoinCirclealertController.addTextField { (textField) in
                textField.placeholder = "code"
            }
            
            JoinCirclealertController.addAction(confirmAction)
            JoinCirclealertController.addAction(cancelAction)
            
            self.present(JoinCirclealertController, animated: true, completion: nil)
        })
        let  createButton = UIAlertAction(title: "Create a Circle", style: .default, handler: { (action) -> Void in
            
            let CreateCirclealertController = UIAlertController(title: "Create a Circle", message: "", preferredStyle: .alert)

            let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
                if (CreateCirclealertController.textFields![0] as? UITextField) != nil{
                    // store your data
                    let title = CreateCirclealertController.textFields?[0].text
                    let description=CreateCirclealertController.textFields?[1].text
                    let code = CreateCirclealertController.textFields?[2].text
                    let creator=SharedPref.sharedpref.prefs.string(forKey: "id")!
                    let param=[
                        "title":title!,
                        "description": description!,
                        "code":code!,
                        "creator": creator
                    ]
                    if (title != "" && code != ""){
                        if Reachability.isConnectedToNetwork() == true {
                        Alamofire.request(self.urlCreationCircle, method: .post, parameters: param).responseJSON{response in
                            if(response.result.isSuccess){
                                if let json=response.result.value{
                                    let jsonResult:Dictionary = json as! Dictionary<String,Any>
                                    
                                    if(jsonResult["error"] as! Bool == false){
                                        let id : String = SharedPref.sharedpref.prefs.string(forKey: "id")!
                                        let param1=[
                                            "user_id": id
                                        ]
                                        
                                        Alamofire.request(self.urlGetCircles, method: .get, parameters: param1).responseJSON{response in
                                            if(response.result.isSuccess){
                                                if let json=response.result.value{
                                                    let jsonResult1:Dictionary = json as! Dictionary<String,Any>
                                                    let jsonNews:NSArray = jsonResult1["circles"] as! NSArray
                                                    self.names.removeAll()
                                                    for i in jsonNews{
                                                        let n : Circle = Circle(dic : i as! [String : Any])
                                                        self.listCircles.append(n)
                                                        self.names.append(n.name)
                                                        self.idTab.append(n.id)
                                                        self.drop.items = self.names
                                                    }
                                                    
                                                    self.drop.title=self.names[Int(SharedPref.sharedpref.prefs.string(forKey: "circle_index")!)!]
                                                }
                                            }
                                            else if(response.result.isFailure){
                                                print("failed circles")
                                            }
                                        }
                                        
                                    }
                                        
                                    else{
                                        let DeleteAlertController = UIAlertController(title: "", message: jsonResult["error_msg"] as! String, preferredStyle: .alert)
                                        
                                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
                                        
                                        DeleteAlertController .addAction(cancelAction)
                                        
                                        self.present(DeleteAlertController , animated: true, completion: nil)
                                    }
                                }
                            }
                            else if(response.result.isFailure){
                                print("failed")
                            }
                        }
                        }else{
                            let internetAlertController = UIAlertController(title: "Warning", message: "Please Check Your Internet Connection", preferredStyle: .alert)
                            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
                            internetAlertController.addAction(cancelAction)
                            self.present(internetAlertController, animated: true, completion: nil)
                        }
                    } else {
                        let DeleteAlertController = UIAlertController(title: "", message: "Empty fields !", preferredStyle: .alert)
                        
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
                        
                        DeleteAlertController .addAction(cancelAction)
                        
                        self.present(DeleteAlertController , animated: true, completion: nil)
                        
                    }
                    
                }
                
             
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
            
            CreateCirclealertController.addTextField { (textField) in
                textField.placeholder = "title"
            }
            CreateCirclealertController.addTextField { (textField) in
                textField.placeholder = "description"
            }
            CreateCirclealertController.addTextField { (textField) in
                textField.placeholder = "code"
            }
            CreateCirclealertController.addAction(confirmAction)
            CreateCirclealertController.addAction(cancelAction)
            
            self.present(CreateCirclealertController, animated: true, completion: nil)
            
            
            
        })
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            print("Cancel button tapped")
        })
        
        
        alertController.addAction(inviteButton)
        alertController.addAction(joinButton)
        alertController.addAction(createButton)
        alertController.addAction(cancelButton)
        
        present(alertController, animated: true, completion: nil)
       
    }
    
    @IBAction func ChooseOption(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "", message: "What would you like to do?", preferredStyle: .actionSheet)
        
        let galleryButton = UIAlertAction(title: "Library", style: .default, handler: { (action) -> Void in
            self.picker.delegate = self
            self.picker.allowsEditing = false
            self.picker.sourceType = .photoLibrary
            self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.present(self.picker, animated: true, completion: nil)

           
        })
        
        let  CameraButton = UIAlertAction(title: "Take Photo", style: .default, handler: { (action) -> Void in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.picker.allowsEditing = false
                self.picker.sourceType = UIImagePickerControllerSourceType.camera
                self.picker.cameraCaptureMode = .photo
                self.picker.modalPresentationStyle = .fullScreen
                self.present(self.picker,animated: true,completion: nil)
            } else {
                print("no camera")
            }
        })
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            print("Cancel button tapped")
        })
        
        alertController.addAction(galleryButton)
        alertController.addAction(CameraButton)
        alertController.addAction(cancelButton)
        
        present(alertController, animated: true, completion: nil)

    }
    
     func imagePickerController(_ picker: UIImagePickerController,
                                       didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let view = self.storyboard? .instantiateViewController(withIdentifier: "postView") as! ShareViewController
            DispatchQueue.main.async {
                view.img2 = image
                self.present(view, animated: true, completion: nil)
            }


        } else{
            print("Something went wrong")
        }
        //imageToPost.contentMode = .scaleAspectFit //3
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    
  
       override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        let DVC:ShareViewController=segue.destination as! ShareViewController
        DVC.img2 = img
     }
  
}

