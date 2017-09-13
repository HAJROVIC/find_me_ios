//
//  MyPostsController.swift
//  findme
//
//  Created by ESPRIT on 04/04/2017.
//  Copyright © 2017 esprit. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import MapleBacon

private let reuseIdentifier = "MyCollectionCell"

class MyPostsController: UICollectionViewController {

    @IBOutlet var MyCollection: UICollectionView!
    let url = "https://findme2017.000webhostapp.com/findme/getNewsByUser.php"
    var listNews : [News] =  []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: MyCollection.bounds.size.width/3, height: MyCollection.bounds.size.width/3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        MyCollection.collectionViewLayout = layout*/
        let id = SharedPref.sharedpref.prefs.string(forKey: "id")!
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
                    self.MyCollection.reloadData()
                    
                }
            }
            else if(response.result.isFailure){
                print("faied22")
            }
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let id = SharedPref.sharedpref.prefs.string(forKey: "id")!
        let param=[
            "id":id
        ]
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
                    self.MyCollection.reloadData()
                    
                }
            }
            else if(response.result.isFailure){
                print("faied22")
            }
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = MyCollection.cellForItem(at: indexPath) {
            performSegue(withIdentifier: "showDetail", sender: cell)
        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        assert(sender as? UICollectionViewCell != nil, "sender is not a collection view")
        
        if let indexPath = self.collectionView?.indexPath(for: sender as! UICollectionViewCell) {
            if segue.identifier == "showDetail" {
                let detailVC: MyPostController = segue.destination as! MyPostController
                detailVC.id = Int(listNews[indexPath.row].id)!
            }
        }
    }
 

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return listNews.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyItem", for: indexPath)

        let image = cell.contentView.viewWithTag(5000) as! UIImageView
        /*let url = URL(string: listNews[indexPath.row].url)
        image.sd_setImage(with: url, placeholderImage: nil, options: [SDWebImageOptions.continueInBackground, SDWebImageOptions.lowPriority, SDWebImageOptions.refreshCached, SDWebImageOptions.handleCookies, SDWebImageOptions.retryFailed]) { (image, error, cacheType, url) in
        }*/
        
        if let imageUrl = URL(string: listNews[indexPath.row].url) , let placeholder = UIImage(named: "placeholder1"){
            image.setImage(withUrl: imageUrl , placeholder: placeholder)
        }

    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
