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
    
    //MapView
    @IBOutlet weak var mapkit: MKMapView!
    //Location Manager
    let locationManager = CLLocationManager();
    //Variable for distance.
    var distanceAmount = 100.00;
    //Array of objects
    var objectArray:[Object] = [];
    //Variable to check if services is on or off.
    var Services = true;
    
    //Label for distance amount.
    @IBOutlet weak var distanceLabel: UILabel!
    //Slider variable
    @IBOutlet weak var sliderButton: UISlider!
    //Services button.
    @IBOutlet weak var LocationServiesButton: UIButton!
    
    //Function that on click turns on and off the servies or the location manager.
    @IBAction func LocationServices(sender: AnyObject) {
        if(Services == true){
            Services = false;
            locationManager.stopUpdatingLocation();
            LocationServiesButton.setTitle("Services Off", forState: UIControlState.Normal);
        }
        else{
            Services = true;
            locationManager.startUpdatingLocation();
            LocationServiesButton.setTitle("Services On", forState: UIControlState.Normal);
        }
    }
    
    //Function that on slider change it updates the distance and changes the coresponding label.
    @IBAction func distanceSlider(sender: AnyObject) {
        self.distanceAmount = Double(sliderButton.value);
        distanceLabel.text = String(sliderButton.value);
        distanceLabel.text = distanceLabel.text!+"m";
    }
    
    //Objects are the seen users that can be updated once initialized.
    class Object {
        var ID : String;
        var Lat : Double;
        var Lon : Double;
        var Seen: Bool;
        
        init(ID: String, Lat: Double, Lon: Double, Seen: Bool){
            self.ID = ID;
            self.Lat = Lat;
            self.Lon = Lon;
            self.Seen = Seen;
        }
    }



    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Setting up the allerts. Parts of these parts are unecessary after testing.
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        let notification = UILocalNotification()
        notification.alertBody = "FriendFinder found someone close to you."
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
        //Setting up location settings and making sure services are on at start.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        mapkit.setUserTrackingMode(MKUserTrackingMode.Follow, animated: true)
        
        Services = true;
        locationManager.startUpdatingLocation();
        LocationServiesButton.setTitle("Services On", forState: UIControlState.Normal);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Starts location when view appears.
    override func viewDidAppear(animated: Bool) {
        Services = true;
        locationManager.startUpdatingLocation();
        LocationServiesButton.setTitle("Services On", forState: UIControlState.Normal);
        print("Start updating location")
    }
    
    //Stops location updating when view disappears.
    override func viewDidDisappear(animated: Bool) {
        locationManager.stopUpdatingLocation()
        Services = false;
        LocationServiesButton.setTitle("Services Off", forState: UIControlState.Normal);
        print("Stop updating location")
    }
    
    //This section is for alerts which have not been implemented due to the reasons that if you are using the app then you can see the person.
    func Alert(){
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        AlertMSG("Friend Finder is looking at your location.");
    }
    
    //Function AlertMSG is used when you want a Alert and you can just pass it a string to show.
    func AlertMSG(msg: String){
        let alertController = UIAlertController(title: "FriendFinder", message:
            msg, preferredStyle: UIAlertControllerStyle.Alert);
        
        alertController.addAction(UIAlertAction(title: "Exit", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            NSLog("Exit Alert")
            });
        
        self.presentViewController(alertController, animated: true, completion: nil);
    }
    
    //Function notificationMSG is used when you want a notification and you can just pass it a string to show.
    func notificationMSG(msg: String){
        let notification = UILocalNotification()
        notification.fireDate = NSDate(timeIntervalSinceNow: 5)
        notification.alertBody = msg;
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    
    //Function for location. Controls location. Prints out coordinates and controlls GET and PUT
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last;
        print("Lat: " + String(format: "%f", (location?.coordinate.latitude)!));
        print("Lon: " + String(format: "%f", (location?.coordinate.longitude)!));
        
        
        
        //print("\nPostcheck: "+String(PostCheck));
        
        //if(PostCheck == 0)
        //{
            //POST(String(UIDevice.currentDevice().name), Lat: String(format: "%f", (location?.coordinate.latitude)!), Lon: String(format: "%f", (location?.coordinate.longitude)!));
        //    PostCheck = 1;
        //}
        
         GET(locations);
        
        
        PUT(String(UIDevice.currentDevice().name), Lat: String(format: "%f", (location?.coordinate.latitude)!), Lon: String(format: "%f", (location?.coordinate.longitude)!));
    }
    
    //Function on error for locations.
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error : " + error.localizedDescription)
    }
    
    //HTTP request for getting all information pertaining to the GET
    func GET(locations: [CLLocation]){
        let url: NSURL = NSURL(string: "http://ec2-52-32-225-1.us-west-2.compute.amazonaws.com/GET/Location")!
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = "GET"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        //let variableString = "Location";
        //print(variableString);
        //request.HTTPBody = variableString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request){
            (let data, let response, let error) in
            guard let _:NSData = data, let _:NSURLResponse = response where error == nil else {
                print("Error");
                return
            }
            //Var dataString is an array of JSON objects that we parse through to get the correct information.
            var dataString = NSString(data: data!, encoding: NSUTF8StringEncoding);
            
            
            let array = ["[", "]", "{", "}", "location", "\""];
            
            //Remove unessecary variables from string of JSON object.
            for string in array{
                    dataString = dataString!.stringByReplacingOccurrencesOfString(string, withString: "");
            }
            //Split String into an array of objects.
            let stringArray = dataString?.componentsSeparatedByString("__v:0,");

            //Loop through array and add each JSON object to the Object class and then to the array.
            for string in stringArray!{
                if(string != ""){
                    let temp = string.componentsSeparatedByString(",");
                    var id = "";
                    var lon = 0.000;
                    var lat = 0.000;
                    //Grab each important section of the JSON object.
                    for t in temp{
                        if(t.rangeOfString("ID:") != nil){
                             id = t.stringByReplacingOccurrencesOfString("ID:", withString: "");
                        }
                        else if(t.rangeOfString("Lon:") != nil){
                             lon = NSString(string: t.stringByReplacingOccurrencesOfString("Lon:", withString: "")).doubleValue;
                        }
                        else if(t.rangeOfString("Lat:") != nil){
                             lat  = NSString(string: t.stringByReplacingOccurrencesOfString("Lat:", withString: "")).doubleValue;
                        }
                    }
                    
                    //Adding the JSON object to the Object class and then to the array.
                    var oldObject = self.objectArray.filter({return $0.ID == id});
                    if(oldObject.count > 0){
                        oldObject[0].Lat = lat;
                        oldObject[0].Lon = lon;
                        if((self.calcDistance(locations, object: oldObject[0]) > self.distanceAmount) && oldObject[0].Seen == true)
                        {
                            oldObject[0].Seen = false;
                        }
                    }
                    else{
                        let newObject = Object(ID: id, Lat: lat, Lon: lon, Seen: false);
                        self.objectArray.append(newObject);
                    }
                    
                    //print(self.objectArray);
                }
            }
            
            //print(self.objectArray);
            
            //Updating the UI field.
            dispatch_async(dispatch_get_main_queue()) {
                // update some UI
                //If a pin is selected it will not updat otherwise clear out the current pins.
                if(self.mapkit.selectedAnnotations.count == 0){
                    self.mapkit.removeAnnotations(self.mapkit.annotations);
                }
                //Adds all objects in array to the map view and if they are within distance notify user.
                for object in self.objectArray{
                    if(object.ID != String(UIDevice.currentDevice().name))
                    {
                        let distanceAway = self.calcDistance(locations, object: object);
                        if(distanceAway < self.distanceAmount && object.Seen == false){
                            self.notificationMSG(object.ID + " is " + String(format: "%f", (distanceAway)) + " meters away from you.");
                            var o = self.objectArray.filter({return $0.ID == object.ID});
                            o[0].Seen = true;
                        }
                        let pinLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake((object.Lat), (object.Lon));
                        let objectAnnotation = MKPointAnnotation();
                        objectAnnotation.coordinate = pinLocation;
                        objectAnnotation.title = object.ID;
                        self.mapkit.addAnnotation(objectAnnotation);
                    }
                }
                //print(self.mapkit.annotations);
            }
            
        }
        
        task.resume();
        
        
    }
    
    //Function calcDistance calculates the distance away from user.
    func calcDistance(locations: [CLLocation], object: Object) -> Double{
        let location = locations.last;
        let pi = M_PI/180;
        let R = 6371000;
        let dLat = ((location?.coordinate.latitude)! - object.Lat) * pi;
        let dLon = ((location?.coordinate.longitude)! - object.Lon) * pi;
        let temp1 = sin(dLat/2)*sin(dLat/2);
        let temp2 = cos(object.Lat*pi)*cos((location?.coordinate.latitude)!*pi)
        let temp3 = sin(dLon/2)*sin(dLon/2);
        let temp = temp1 + temp2 * temp3;
        let variable = 2 * atan2(sqrt(temp), sqrt(1-temp));
        let distance = variable * Double(R);
        return distance;
    }

    //Function PUT adds or updates your information to the location database.
    func PUT(ID: String, Lat: String, Lon: String){
        let url: NSURL = NSURL(string: "http://ec2-52-32-225-1.us-west-2.compute.amazonaws.com/POST/Update")!
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        
        var variableString = "ID="+ID+"&Lat="+Lat+"&Lon="+Lon;
        variableString=variableString.stringByReplacingOccurrencesOfString(" ", withString: "+");
        //print(variableString);
        request.HTTPBody = variableString.dataUsingEncoding(NSUTF8StringEncoding);
        
        let task = session.dataTaskWithRequest(request){
            (let data, let response, let error) in
            guard let _:NSData = data, let _:NSURLResponse = response where error == nil else {
                print("Error");
                return;
            }
            _ = NSString(data: data!, encoding: NSUTF8StringEncoding);
            //print("PUT\n");
            //print(dataString!);
            
            dispatch_async(dispatch_get_main_queue()) {
                // update some UI
                
            }
            
        }

        
        task.resume();
        
        
    }
    
        //Function POST used to add new users to the database but will not update users information.
/*    func POST(ID: String, Lat: String, Lon: String){
        let url: NSURL = NSURL(string: "http://ec2-52-32-225-1.us-west-2.compute.amazonaws.com/POST/Location")!
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        
        var variableString = "ID="+ID+"&Lat="+Lat+"&Lon="+Lon;
        variableString=variableString.stringByReplacingOccurrencesOfString(" ", withString: "+");
        //print(variableString);
        request.HTTPBody = variableString.dataUsingEncoding(NSUTF8StringEncoding);
        
        let task = session.dataTaskWithRequest(request){
            (let data, let response, let error) in
            guard let _:NSData = data, let _:NSURLResponse = response where error == nil else {
                print("Error");
                return;
            }
            let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding);
            print("POST\n");
            //print(dataString!);
            
            dispatch_async(dispatch_get_main_queue()) {
                // update some UI
                
            }
            
        }
        
        task.resume();
        
        
    }

*/

}

