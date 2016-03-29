//
//  ViewController.swift
//  FriendFinder
//
//  Created by Eli on 3/29/16.
//  Copyright © 2016 ZachariahEliTaylor. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate{
    
    @IBOutlet weak var mapkit: MKMapView!
    let locationManager = CLLocationManager();

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        mapkit.setUserTrackingMode(MKUserTrackingMode.Follow, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        locationManager.startUpdatingLocation()
        print("Start updating location")
    }
    
    override func viewDidDisappear(animated: Bool) {
        locationManager.stopUpdatingLocation()
        print("Stop updating location")
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        print("Lat: " + String(format: "%f", (location?.coordinate.latitude)!));
        print("Lon: " + String(format: "%f", (location?.coordinate.longitude)!));
        
        let pinLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake((location?.coordinate.latitude)! + 0.0001, (location?.coordinate.longitude)! + 0.0001);
        let objectAnnotation = MKPointAnnotation()
        objectAnnotation.coordinate = pinLocation
        objectAnnotation.title = "Find me"
        mapkit.addAnnotation(objectAnnotation)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error : " + error.localizedDescription)
    }

}

