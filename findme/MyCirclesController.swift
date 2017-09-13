//
//  MyCirclesController.swift
//  findme
//
//  Created by ESPRIT on 04/04/2017.
//  Copyright © 2017 esprit. All rights reserved.
//

import UIKit
import Alamofire

class MyCirclesController: UITableViewController {

    @IBOutlet var MyTable: UITableView!
    let url = "https://findme2017.000webhostapp.com/findme/getCirclesCreatedByUser.php"
    let urlDeleteCircle = "https://findme2017.000webhostapp.com/findme/deleteCircle.php"
    let urlUpdateCircle = "https://findme2017.000webhostapp.com/findme/updateCircle.php"
    var listCircles : [Circle] =  []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let id = SharedPref.sharedpref.prefs.string(forKey: "id")!
        let param=[
            "user_id":id
            
        ]
        Alamofire.request(url, method: .post, parameters: param).responseJSON{response in
            if(response.result.isSuccess){
                if let json=response.result.value{
                    let jsonResult:Dictionary = json as! Dictionary<String,Any>
                    let jsonNews:NSArray = jsonResult["circles"] as! NSArray
                    for i in jsonNews{
                        let c : Circle = Circle(dic : i as! [String : Any])
                        self.listCircles.append(c)
                        
                    }
                    self.MyTable.reloadData()
                    
                }
            }
            else if(response.result.isFailure){
                print("failed33")
            }
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listCircles.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "circleCell")!
        let lbl = cell.contentView.viewWithTag(3000) as! UILabel
        lbl.text=listCircles[indexPath.row].name
        let btn = cell.contentView.viewWithTag(3001) as! UIButton
        btn.isHidden=true
        let btn1 = cell.contentView.viewWithTag(3002) as! UIButton
        btn1.isHidden=true
        let btn2 = cell.contentView.viewWithTag(3003) as! UIButton
        btn2.isHidden=true
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = MyTable.cellForRow(at: indexPath as IndexPath) {
            let btn = cell.contentView.viewWithTag(3001) as! UIButton
            btn.isHidden=false
            let btn1 = cell.contentView.viewWithTag(3002) as! UIButton
            btn1.isHidden=false
            let btn2 = cell.contentView.viewWithTag(3003) as! UIButton
            btn2.isHidden=false
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = MyTable.cellForRow(at: indexPath as IndexPath) {
            let btn = cell.contentView.viewWithTag(3001) as! UIButton
            btn.isHidden=true
            let btn1 = cell.contentView.viewWithTag(3002) as! UIButton
            btn1.isHidden=true
            let btn2 = cell.contentView.viewWithTag(3003) as! UIButton
            btn2.isHidden=true
        }
    }
    @IBAction func DeleteCircle(_ sender: UIButton) {
        
        let DeleteAlertController = UIAlertController(title: "", message: "Did you want really to delete this Circle ?", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Delete", style: .default) { (_) in
            let index:IndexPath = self.MyTable.indexPathForSelectedRow!
            let circle_id :Int = Int(self.listCircles[index.row].id)!
            
            let param=[
                "circleId": circle_id
            ]
            Alamofire.request(self.urlDeleteCircle, method: .get, parameters: param).responseJSON{response in
                if(response.result.isSuccess){
                    self.listCircles.remove(at: index.row)
                    self.MyTable.reloadData()
                }
                else if(response.result.isFailure){
                    print("failed delete circle !")
                }
            }
      }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        DeleteAlertController .addAction(confirmAction)
        DeleteAlertController .addAction(cancelAction)
        
        self.present(DeleteAlertController , animated: true, completion: nil)
        


    }
    @IBAction func ShowInfos(_ sender: UIButton) {
        let index:IndexPath = self.MyTable.indexPathForSelectedRow!
        let s:String = self.listCircles[index.row].desc+"\n"+self.listCircles[index.row].code
        let ShowAlertController = UIAlertController(title: self.listCircles[index.row].name, message: s, preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        ShowAlertController .addAction(cancelAction)
                self.present(ShowAlertController , animated: true, completion: nil)

    }
    
    
    @IBAction func Update(_ sender: UIButton) {
        let index:IndexPath = self.MyTable.indexPathForSelectedRow!
        let circle_id  = self.listCircles[index.row].id
        
        let CreateCirclealertController = UIAlertController(title: "Update", message: "", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Save", style: .default) { (_) in
            let title = CreateCirclealertController.textFields?[0].text
            let description=CreateCirclealertController.textFields?[1].text
            let code = CreateCirclealertController.textFields?[2].text
            
            
            let param=[
                "circle_id": circle_id!,
                "code":code!,
                "title":title!,
                "description":description!
            ]
            Alamofire.request(self.urlUpdateCircle, method: .get, parameters: param).responseJSON{response in
                if(response.result.isSuccess){
                    print("heloooooo")
                    
                }
                else if(response.result.isFailure){
                    print("failed158")
                }
            }
            
          
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        CreateCirclealertController.addTextField { (textField) in
            textField.text = self.listCircles[index.row].name
        }
        CreateCirclealertController.addTextField { (textField) in
            textField.text = self.listCircles[index.row].desc
        }
        CreateCirclealertController.addTextField { (textField) in
            textField.text = self.listCircles[index.row].code
        }
        
        CreateCirclealertController.addAction(confirmAction)
        CreateCirclealertController.addAction(cancelAction)
        
        self.present(CreateCirclealertController, animated: true, completion: nil)

    }
    


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
