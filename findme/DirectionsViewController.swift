//
//  DirectionsViewController.swift
//  findme
//
//  Created by findme on 12/04/2017.
//  Copyright © 2017 esprit. All rights reserved.
//

import UIKit
import STLocationRequest
import CoreLocation
import MapKit

class DirectionsViewController: UIViewController, MKMapViewDelegate  {
    @IBOutlet weak var MyMap: MKMapView!
    let regionRadius: CLLocationDistance = 10000
    let locationManager = CLLocationManager()
    var dest = CLLocationCoordinate2D()
    var myPosition = CLLocationCoordinate2D()
    var name:String=""

    override func viewDidLoad() {
        super.viewDidLoad()
        MyMap.delegate=self
        //let initial = CLLocation(latitude: 36.904999, longitude: 10.299141)
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
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
                    self.locationManager.startUpdatingLocation()
                }
            }
        } else {
            // Location Services are disabled
            print("Location Services are disabled")
        }
        
        
        
        
        //let sourceLocation = CLLocationCoordinate2D(latitude: 36.89946300, longitude: 10.18943300)
        let sourceLocation = myPosition
        let destinationLocation = dest
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = "Me"
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = name
        
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        self.MyMap.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .walking
        let directions = MKDirections(request: directionRequest)
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            self.MyMap.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.MyMap.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
           }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
 
    }
    @IBAction func Cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        
        return renderer
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
    


}
extension DirectionsViewController: STLocationRequestControllerDelegate {
    
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

extension DirectionsViewController: CLLocationManagerDelegate {
    
    /// CLLocationManagerDelegate DidFailWithError Methods
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error. The Location couldn't be found. \(error)")
    }
    
    /// CLLocationManagerDelegate didUpdateLocations Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
        print("000000000000didUpdateLocations UserLocation: \(String(describing: locations.last))")
        let initialLocation = CLLocation(latitude: (locations.last?.coordinate.latitude)!, longitude: (locations.last?.coordinate.longitude)!)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        MyMap.setRegion(coordinateRegion, animated: true)
    }
    
}

