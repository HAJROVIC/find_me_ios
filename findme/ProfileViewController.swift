//
//  ProfileViewController.swift
//  findme
//
//  Created by findme on 14/03/2017.
//  Copyright © 2017 esprit. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SwiftSpinner
import MapleBacon



class ProfileViewController: UIViewController,UIImagePickerControllerDelegate,
UINavigationControllerDelegate   {
    
    @IBOutlet weak var MyPosts: UIView!
    @IBOutlet weak var MyCirces: UIView!
    @IBOutlet weak var segmented: UISegmentedControl!
    @IBOutlet weak var image: UIImageView!
    let picker = UIImagePickerController()
    let urlUpdateImage = "https://findme2017.000webhostapp.com/findme/updateUserImage.php"
    let email = SharedPref.sharedpref.prefs.string(forKey: "email")! as String
    let id = SharedPref.sharedpref.prefs.string(forKey: "id")! as String
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        
//self.MyPostsCollection.delegate = self
        //self.MyPostsCollection.dataSource = self

        
        //segmented.customizeAppearance(for: 1)
        image.layer.cornerRadius = image.frame.size.width/2
        image.clipsToBounds = true
        /*let url2 = URL(string: SharedPref.sharedpref.prefs.string(forKey: "picture")! as String)
        image.sd_setImage(with: url2, placeholderImage: nil, options: [SDWebImageOptions.continueInBackground, SDWebImageOptions.lowPriority, SDWebImageOptions.refreshCached, SDWebImageOptions.handleCookies, SDWebImageOptions.retryFailed]) { (image, error, cacheType, url2) in
        }*/
        if let imageUrl = URL(string: SharedPref.sharedpref.prefs.string(forKey: "picture")! as String) , let placeholder = UIImage(named: "person-placeholder"){
            image.setImage(withUrl: imageUrl , placeholder: placeholder)
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.MyPosts.alpha = 1
            self.MyCirces.alpha = 0
        })

      
    }
    
    
    @IBAction func Logout(_ sender: UIButton) {
        
        SharedPref.sharedpref.setSharedprefs(email:"",
                                             id:0,
                                             fullName : "",
                                             picture :"",
                                             password : "",
                                             phone: 0,
                                             position:"",
                                             isLogged:0)
        
        self.performSegue(withIdentifier: "logout", sender:self)

         }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func OnChange(_ sender: UISegmentedControl) {
        switch segmented.selectedSegmentIndex
        {
        case 0:
            UIView.animate(withDuration: 0.5, animations: {
                self.MyPosts.alpha = 1
                self.MyCirces.alpha = 0
            })
        case 1:
            UIView.animate(withDuration: 0.5, animations: {
                self.MyCirces.alpha = 1
                self.MyPosts.alpha = 0
            })

        default:
            break;
        }
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
extension UISegmentedControl {
    
    func customizeAppearance(for height: Int) {
        
        setTitleTextAttributes([NSFontAttributeName:UIFont(name:"Helvetica Neue", size:13.0)!,NSForegroundColorAttributeName:UIColor.black], for:.normal)
        setTitleTextAttributes([NSFontAttributeName:UIFont(name:"Helvetica Neue", size:13.0)!,NSForegroundColorAttributeName:UIColor.white], for:.selected)
        setDividerImage(UIImage().colored(with: .clear, size: CGSize(width: 1, height: height)), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        setBackgroundImage(UIImage().colored(with: .clear, size: CGSize(width: 1, height: height)), for: .normal, barMetrics: .default)
        setBackgroundImage(UIImage().colored(with: UIColor.init(red: 0/255.0, green: 122/255.0, blue: 255/255.0, alpha: 1.0), size: CGSize(width: 1, height: height)), for: .selected, barMetrics: .default);
 
        /*for  borderview in subviews {
            let upperBorder: CALayer = CALayer()
            upperBorder.backgroundColor = UIColor.init(red: 0/255.0, green: 122/255.0, blue: 255/255.0, alpha: 1.0).cgColor
            upperBorder.frame = CGRect(x: 0, y: borderview.frame.size.height-1, width: borderview.frame.size.width, height: 1)
            borderview.layer.addSublayer(upperBorder)
        }*/
        
    }
}
extension UIImage {
    
    func colored(with color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor);
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
}


