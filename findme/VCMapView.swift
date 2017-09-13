////
//  VCMapView.swift
//  findme
//
//  Created by findme on 14/03/2017.
//  Copyright © 2017 esprit. All rights reserved.
//

import MapKit

extension MapViewController: MKMapViewDelegate {
    
    public func mapView(_ mapView: MKMapView,
                 viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        
        let reuseId = "test"
        let cpa = annotation as! CustomPointAnnotation
        let url = URL(string: cpa.imageName as String!)
        var data = try?Data(contentsOf: url!)
        var img = UIImage(data: data!);
        
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView?.canShowCallout = true
            
            DispatchQueue.global().async {
                data = try?Data(contentsOf: url!)
                DispatchQueue.main.async {
                    img = UIImage(data: data!)!
                }
            }
            
            let size = CGSize(width: 50, height: 50)
            UIGraphicsBeginImageContext(size)
            img?.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            let imageView: UIImageView = UIImageView(image: resizedImage)
            var layer: CALayer = CALayer()
            layer = imageView.layer
            
            layer.masksToBounds = true
            layer.cornerRadius = CGFloat((resizedImage?.size.width)!/2)
            
            UIGraphicsBeginImageContext(imageView.bounds.size)
            layer.render(in: UIGraphicsGetCurrentContext()!)
            let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            anView?.image = roundedImage
            
            if cpa.idUser != SharedPref.sharedpref.prefs.string(forKey: "id")! {
                let btn = MyButton(type: .detailDisclosure)
                let img = UIImage(named: "direction")
                btn.setImage(img, for: .normal)
                btn.addTarget(self, action: #selector(MapViewController.SendLocation(sender:)), for: .touchUpInside)
                anView?.rightCalloutAccessoryView = btn
            }
            }
        else {
            anView?.annotation = annotation
            
        }
        if let button = anView?.rightCalloutAccessoryView as? MyButton{
        button.annotation = annotation
        }

        return anView
    }
    
    func SendLocation(sender: MyButton) {
        destination = (sender.annotation?.coordinate)!
        name = ((sender.annotation?.title)!)!
        self.performSegue(withIdentifier: "directions", sender:self)
    }
    
}
class MyButton: UIButton {
    var annotation : MKAnnotation? = nil
}
