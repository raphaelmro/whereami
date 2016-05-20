//
//  ViewController.swift
//  Where Am I
//
//  Created by Raphael Onofre on 5/19/16.
//  Copyright © 2016 Raphael Onofre. All rights reserved.
//

import MapKit
import UIKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var latitudeResult: UILabel!
    @IBOutlet weak var longitudeResult: UILabel!
    @IBOutlet weak var courseResult: UILabel!
    @IBOutlet weak var speedResult: UILabel!
    @IBOutlet weak var altitudeResult: UILabel!
    @IBOutlet weak var nearestAddResult: UILabel!
    @IBOutlet weak var map: MKMapView!
    
    var locationManager = CLLocationManager()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0]
        
        let userLat = userLocation.coordinate.latitude
        let userLon = userLocation.coordinate.longitude
        
    
        let latitude: CLLocationDegrees = userLat
        let longitude: CLLocationDegrees = userLon
        let latDelta: CLLocationDegrees = 0.05
        let lonDelta: CLLocationDegrees = 0.05
        let span = MKCoordinateSpanMake(latDelta, lonDelta)
        let location = CLLocationCoordinate2DMake(latitude, longitude)
        let region = MKCoordinateRegionMake(location, span)
        
        self.map.setRegion(region, animated: true)
        
        //setting data into view
        latitudeResult.text = latitude.description
        longitudeResult.text = longitude.description
        courseResult.text = userLocation.course.description
        speedResult.text = userLocation.speed.description
        altitudeResult.text = userLocation.altitude.description
        //setting nearest address
        CLGeocoder().reverseGeocodeLocation(manager.location!) { (placemark, error) in
            if placemark!.count > 0 {
                let pm = placemark![0] as CLPlacemark
                self.displayLocationInfo(pm)
            } else{
                print("Problem with geocoder")
            }
        }
    }
    
    func displayLocationInfo(placemark: CLPlacemark){
        locationManager.stopUpdatingLocation() //stop updating location to save battery life
        
        let nearestAddress = placemark.locality! + " " + placemark.postalCode! + " - " + placemark.administrativeArea! + " " + placemark.country!
        
        nearestAddResult.text = nearestAddress
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

