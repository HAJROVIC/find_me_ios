//
//  MainViewController.swift
//  findme
//
//  Created by ESPRIT on 16/02/2017.
//  Copyright © 2017 esprit. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    
    var user:[NSManagedObject] = []
    var cnt = 0



    override func viewDidLoad() {
        
        self.navigationItem.title="HOME"
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        do {
            user = try managedContext.fetch(fetchRequest)
            cnt = user.count
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        // Do any additional setup after loading the view.


        // Do any additional setup after loading the view.
    }
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //let DVC:DetailsController=segue.destination as! DetailsController
        //DVC.name=user[indexPath.row].value(forKey: "name")as! String
        
            }
    

}
