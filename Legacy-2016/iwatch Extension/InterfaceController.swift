//
//  InterfaceController.swift
//  iwatch Extension
//
//  Created by Eastern on 1/6/16.
//  Copyright © 2016 Nguyen Hoang. All rights reserved.
//

import WatchKit
import Foundation
import CoreLocation

class InterfaceController: WKInterfaceController, CLLocationManagerDelegate {

    @IBOutlet var lat: WKInterfaceLabel!
    @IBOutlet var lng: WKInterfaceLabel!
    @IBOutlet var address: WKInterfaceLabel!
    
    let locationManager = CLLocationManager()
   
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
    }

    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("ExtensionDelegate: \(NSDate())  - locationManager didUpdateLocations")
        
        guard let mostRecentLocation = locations.last else { return }
        let place = mostRecentLocation.coordinate
        
        self.lat.setText(String(place.latitude))
        self.lng.setText(String(place.longitude))
        
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: place.latitude, longitude: place.longitude)
        geocoder.reverseGeocodeLocation(location) {
            (placemarks, error) -> Void in
                let placeArray = placemarks as [CLPlacemark]!
                var placeMark: CLPlacemark!
                placeMark = placeArray?[0]
            if(placeMark != nil){
                let address = placeMark.addressDictionary!["FormattedAddressLines"]!.componentsJoinedByString(", ")
                self.address.setText(address)
            }else{
                self.address.setText("")
            }
            
        }
    }
    

    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Errore ricezione posizione.")
    }


    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
