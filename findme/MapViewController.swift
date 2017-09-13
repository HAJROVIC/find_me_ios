//
//  MapViewController.swift
//  findme
//
//  Created by findme on 14/03/2017.
//  Copyright © 2017 esprit. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import SDWebImage
import STLocationRequest
import CoreLocation



class MapViewController: UIViewController {

    
    @IBOutlet weak var MyMap: MKMapView!
    let regionRadius: CLLocationDistance = 10000
    var cmp:Int=0
    let locationManager = CLLocationManager()
    let url = "https://findme2017.000webhostapp.com/findme/getFriends.php"
    let url1 = "https://findme2017.000webhostapp.com/findme/updateUserPosition.php"
    public var destination = CLLocationCoordinate2D();
    public var source = CLLocationCoordinate2D();
    public var name:String = ""
    var listUsers : [Friend] =  []
    public var initial = CLLocation(latitude: 0, longitude: 0)

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Reachability.isConnectedToNetwork() == true {
            let param=[
                "circle_id": SharedPref.sharedpref.prefs.string(forKey: "circle_id")!
            ]
            Alamofire.request(url, method: .post, parameters: param).responseJSON{response in
                if(response.result.isSuccess){
                    if let json=response.result.value{
                        self.listUsers.removeAll()
                        let jsonResult:Dictionary = json as! Dictionary<String,Any>
                        let jsonNews:NSArray = jsonResult["users"] as! NSArray
                        for i in jsonNews{
                            let n : Friend = Friend(dic : i as! [String : Any])
                            self.listUsers.append(n)
                        }
                        print(self.listUsers.count)
                        
                        for j in self.listUsers {
                            print("!!!!!!!!!!!!!!!!!!!!!!!!")
                            
                            var MyStringArray = j.position.components(separatedBy: ",")
                            
                            let lat:Float = (MyStringArray[0] as NSString).floatValue
                            let long:Float = (MyStringArray[1] as NSString).floatValue
                            
                            let info1 = CustomPointAnnotation()
                            info1.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long))
                            let distination = CLLocation(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long))
                            var distanceInMeters = self.initial.distance(from: distination)
                            var desc :String
                            if(distanceInMeters <= 1609)
                            {
                                desc = " meters far."
                            }
                            else
                            {
                                distanceInMeters = distanceInMeters/1609
                                desc = " miles far."
                                
                            }
                            info1.title = j.name
                            info1.subtitle = String(Int(distanceInMeters))+desc
                            info1.imageName = j.picture
                            info1.idUser = j.id
                            self.MyMap.addAnnotation(info1)
                            
                            
                            
                        }
                        
                        
                        
                    }
                }
                else if(response.result.isFailure){
                    print("failed friends")
                }
            }
            
            
            if CLLocationManager.locationServicesEnabled() {
                if CLLocationManager.authorizationStatus() == .denied {
                    // Location Services are denied
                    print("Location Services are denied")
                } else {
                    if CLLocationManager.authorizationStatus() == .notDetermined{
                        // The user has never been asked about his location show the locationRequest Screen
                        // Just play around with the setMapViewAlphaValue and setBackgroundViewColor parameters, to match with your design of your app
                        // Also you can initialize an STLocationRequest Object and set all attributes
                        // and at the end call presentLocationRequestController
                        self.presentLocationRequestController()
                    } else {
                        // The user has already allowed your app to use location services
                        DispatchQueue.global(qos: .userInitiated).async {
                            self.locationManager.startUpdatingLocation()
                        }
                    }
                }
            } else {
                // Location Services are disabled
                print("Location Services are disabled")
            }
            
            // Do any additional setup after loading the view.
        } else {
            let internetAlertController = UIAlertController(title: "Warning", message: "Please Check Your Internet Connection", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
            internetAlertController.addAction(cancelAction)
            self.present(internetAlertController, animated: true, completion: nil)
            
        }

        
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        //let circleId:String = idTab[Int(SharedPref.sharedpref.prefs.string(forKey: "circle_index")!)!]
        
        
    }

    func presentLocationRequestController(){
        let locationRequestController = STLocationRequestController.getInstance()
        locationRequestController.titleText = "We need your location for some awesome features"
        locationRequestController.allowButtonTitle = "Alright"
        locationRequestController.notNowButtonTitle = "Not now"
        locationRequestController.mapViewAlpha = 0.9
        locationRequestController.backgroundColor = UIColor.lightGray
        locationRequestController.authorizeType = .requestWhenInUseAuthorization
        locationRequestController.delegate = self
        locationRequestController.present(onViewController: self)
    }
  
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let DVC:DirectionsViewController=segue.destination as! DirectionsViewController
        DVC.dest = destination
        DVC.name = name
        DVC.myPosition = source
    }
 

}
extension MapViewController: STLocationRequestControllerDelegate {
    
    /// STLocationRequest Delegate Methods
    func locationRequestControllerDidChange(_ event: STLocationRequestControllerEvent) {
        switch event {
        case .locationRequestAuthorized:
            print("The user accepted the use of location services")
            self.locationManager.startUpdatingLocation()
            break
        case .locationRequestDenied:
            print("The user denied the use of location services")
            break
        case .notNowButtonTapped:
            print("The Not now button was tapped")
            break
        case .didPresented:
            print("STLocationRequestController did presented")
            break
        case .didDisappear:
            print("STLocationRequestController did disappear")
            break
        }
    }
    
}

// MARK: - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
    
    /// CLLocationManagerDelegate DidFailWithError Methods
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error. The Location couldn't be found. \(error)")
    }
    
    /// CLLocationManagerDelegate didUpdateLocations Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
        source = (locations.last?.coordinate)!
        print("!!!!!!!didUpdateLocations UserLocation: \(String(describing: locations.last))")
        initial = CLLocation(latitude: (locations.last?.coordinate.latitude)!, longitude: (locations.last?.coordinate.longitude)!)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(initial.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        DispatchQueue.global(qos: .userInitiated).async {
            self.MyMap.setRegion(coordinateRegion, animated: true)
        }
        
        let position:String=String(initial.coordinate.latitude)+","+String(initial.coordinate.longitude)
        let id : String = SharedPref.sharedpref.prefs.string(forKey: "id")!
        //let s :String = "aaaaaaa"
        let param1=[
           "id":id,
            "position":position
        ]
        Alamofire.request(self.url1, method: .get, parameters: param1).responseString{response in
            if response.result.value != nil{
                //SharedPref.sharedpref.setPosition(position : position )
            }
            else if(response.result.isFailure){
                print(response.result.error.debugDescription)
            }
        }
    }
    
}
