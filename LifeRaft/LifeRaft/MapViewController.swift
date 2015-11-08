//
//  MapViewController.swift
//  LifeRaft
//
//  Created by Joe Jacob on 11/7/15.
//  Copyright © 2015 sbg11. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase
import SwiftyJSON
import CoreLocation

class MapViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    // group cannot exceed max of 100 people
    var markers = [GMSMarker?](count: 100, repeatedValue: nil)
    var uberMarkers = [GMSMarker?](count: 100, repeatedValue: nil)
    var groupMems = [String: [String: String]]()   // list of people in group
    var uberMems = [String: [String: String]]()   // list of people in group
    let locationManager = CLLocationManager()
    let camera = GMSCameraPosition.cameraWithLatitude(36.0032805, longitude:-78.9401984, zoom:6)
    var userCoord = CLLocationCoordinate2D(latitude: -33.868, longitude: 151.2086)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
        }
        var mapView = GMSMapView.mapWithFrame(self.view.bounds, camera:camera)
        mapView.delegate = self
        
        
        
        // updating from database
        var memberRef = myRootRef.childByAppendingPath("group1/members/")
        var uberRef = myRootRef.childByAppendingPath("group1/ubers/")
        print("WOOOOOO")
        memberRef.observeEventType(FEventType.Value, withBlock: {
            snapshot in let json = JSON(snapshot.value)
            for (r , k) in json {
                print("memeememmeber ref")
                print("memeememmeber ref")
                print("memeememmeber ref")
                print(r)
                var testGroup = [String:String]()
                for (key, val) in k {
                    testGroup[String(key)] = String(val)
                }
                self.groupMems[String(r)] = testGroup
            }
            self.updatePeople(self.groupMems, mapView:mapView)
            print("\(self.groupMems.count)")
        })
       // var numPeopleInGroup = self.groupMems.count // number of people in the group
        var numPeopleInGroup = 6
        
        print("\(self.groupMems.count)")
        
        
        uberRef.observeEventType(FEventType.Value, withBlock: {
            snapshot in let json = JSON(snapshot.value)
            var testUber = [String:String]()
            for (r , k) in json {
                for (key, val) in k {
                    testUber[key] = String(val)
                }
                self.uberMems[String(r)] = testUber
            }
            self.updateCars(self.uberMems, mapView: mapView)
        })
        var numUbers = self.uberMems.count // number of people in the group
        
        
        // battery things
        // battery
        /*UIDevice.currentDevice().batteryMonitoringEnabled = true
        m.snippet = "Battery: \(UIDevice.currentDevice().batteryLevel)"
        // friend locations*/
        // TODO: the title of each marker will be the friend's initials
        
        
        memberRef.observeEventType(FEventType.ChildAdded, withBlock: {
            snapshot in let json = JSON(snapshot.value)
            for (r , k) in json {
                var testGroup = [String:String]()
                for (key, val) in k {
                   
                    testGroup[String(key)] = String(val)
                }
                self.groupMems[String(r)] = testGroup
            }
            self.updatePeople(self.groupMems, mapView: mapView)
            
        })
        
        memberRef.observeEventType(FEventType.ChildChanged, withBlock: {
            snapshot in let json = JSON(snapshot.value)
            for (r , k) in json {
                var testGroup = [String:String]()
                for (key, val) in k {
                 
                    testGroup[String(key)] = String(val)
                }
                self.groupMems[String(r)] = testGroup
            }
            self.updatePeople(self.groupMems, mapView: mapView)
            
        })
        
        memberRef.observeEventType(FEventType.ChildRemoved, withBlock: {
            snapshot in let json = JSON(snapshot.value)
            for (r , k) in json {
                var testGroup = [String:String]()
                for (key, val) in k {
                    
                    testGroup[String(key)] = String(val)
                }
                self.groupMems[String(r)] = testGroup
            }
            self.updatePeople(self.groupMems, mapView: mapView)
            
        })
        
        uberRef.observeEventType(FEventType.ChildAdded, withBlock: {
            snapshot in let json = JSON(snapshot.value)
            for (r , k) in json {
                var testUber = [String:String]()
                for (key, val) in k {
                
                    testUber[String(key)] = String(val)
                }
                self.groupMems[String(r)] = testUber
            }
            self.updateCars(self.uberMems, mapView: mapView)
            
        })
        
        uberRef.observeEventType(FEventType.ChildRemoved, withBlock: {
            snapshot in let json = JSON(snapshot.value)
            for (r , k) in json {
                var testUber = [String:String]()
                for (key, val) in k {
                    
                    testUber[String(key)] = String(val)
                }
                self.groupMems[String(r)] = testUber
            }
            self.updateCars(self.uberMems, mapView: mapView)
            
        })
        
        uberRef.observeEventType(FEventType.ChildChanged, withBlock: {
            snapshot in let json = JSON(snapshot.value)
            for (r , k) in json {
                var testUber = [String:String]()
                for (key, val) in k {
                    
                    testUber[String(key)] = String(val)
                }
                self.groupMems[String(r)] = testUber
            }
            self.updateCars(self.uberMems, mapView: mapView)
            
        })
        /*for i in 0...(numPeopleInGroup-1) {
            let posx: CLLocationDegrees = -33.868 + Double(i)
            let posy: CLLocationDegrees = 151.2086 - Double(i)
            let coord = CLLocationCoordinate2DMake(posx, posy)
            bounds.includingCoordinate(coord)
            var m = GMSMarker()
            m.position = coord
            m.icon = UIImage(named: "smiley-face")
            
            // distance from current user
            let ccoord = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
            let dist = Double(round((ccoord.distanceFromLocation(base)/1000) * Double(0.62137) * 10)/10)
            m.title = "\(String(i))  \(dist) mi"
            
            // battery
            UIDevice.currentDevice().batteryMonitoringEnabled = true
            m.snippet = "Battery: \(UIDevice.currentDevice().batteryLevel)"
            
            m.appearAnimation = kGMSMarkerAnimationPop
            m.map = mapView
            markers[i] = m
        }*/
        
        
        // updating bounds
        self.view = mapView
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        self.userCoord = locValue
        let id = "3651"
        var memRef = (myRootRef.childByAppendingPath("group1/members/"))
        memRef.observeEventType(FEventType.Value, withBlock: {
            snapshot in let json = JSON(snapshot.value)
            for (r , k) in json {
                if(String(r) == id) {
                    var testGroup = [String:String]()
                    for (key, val) in k {
                        testGroup[String(key)] = String(val)
                    }
                    let cat = "\(locValue.latitude) \(locValue.longitude)"
                    testGroup["Location"] = cat
                    UIDevice.currentDevice().batteryMonitoringEnabled = true
                    testGroup["Battery"] = "\(UIDevice.currentDevice().batteryLevel)"
                    let userRef = myRootRef.childByAppendingPath("group1/members/\(id)")
                    userRef.updateChildValues(["Location":cat])
                    self.groupMems[String(r)] = testGroup
                }
            }
            //self.updatePeople(self.groupMems, mapView: mapView)
        })
        
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    
    func updatePeople(gM:[String: [String:String]], mapView: GMSMapView) {
        var i = 0
        var bounds = GMSCoordinateBounds() // coord bounds
        print(self.groupMems)
        for (r,k) in self.groupMems {
            if k["Location"] != nil{
                print(r)
                
                print(" toooooo \(k)")
                let latlong = k["Location"]!.characters.split{$0 == " "}.map(String.init)
                let posx: CLLocationDegrees = Double(latlong[0])!
                let posy: CLLocationDegrees = Double(latlong[1])!
                let coord = CLLocationCoordinate2DMake(posx, posy)
                bounds.includingCoordinate(coord)
                var m = GMSMarker()
                m.position = coord
                m.icon = UIImage(named: "smiley-face")
                
                // distance from current user
                let ccoord = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
                var locDummy = CLLocation(latitude: self.userCoord.latitude, longitude: self.userCoord.longitude)
                let dist = Double(round((ccoord.distanceFromLocation(locDummy)/1000) * Double(0.62137) * 10)/10)
                m.title = "\(k["Name"]!)  \(dist) mi"
                m.snippet = "Battery: \(k["Battery"]!)%"
                
                
                m.appearAnimation = kGMSMarkerAnimationPop
                m.map = mapView
                markers[i] = m
                i++
                var camUpdate = GMSCameraUpdate.fitBounds(bounds, withPadding:30.0)
                mapView.moveCamera(camUpdate)
            }
        }
        
    }
    
    func updateCars(uM: [String: [String:String]], mapView: GMSMapView) {
        var l = 0
        var bounds = GMSCoordinateBounds() // coord bounds
        for (ub, us) in self.uberMems {
            if us["location"] != nil {
                let latlong = us["location"]!.characters.split{$0 == " "}.map(String.init)
                let posx: CLLocationDegrees = Double(latlong[0])!
                let posy: CLLocationDegrees = Double(latlong[1])!
                let coord = CLLocationCoordinate2DMake(posx, posy)
                var u = GMSMarker()
                bounds.includingCoordinate(coord)
                u.position = coord
                u.icon = UIImage(named: "uber-car")
                
                // distance from current user
                let ccoord = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
                var locDummy = CLLocation(latitude: self.userCoord.latitude, longitude: self.userCoord.longitude)
                let dist = Double(round((ccoord.distanceFromLocation(locDummy)/1000) * Double(0.62137) * 10)/10)
                u.title = "\(dist) mi"
                
                u.appearAnimation = kGMSMarkerAnimationPop
                u.map = mapView
                self.uberMarkers[l] = u
                l++
                var camUpdate = GMSCameraUpdate.fitBounds(bounds, withPadding:30.0)
                mapView.moveCamera(camUpdate)
            }
        }
    }
    
    /*func mapView(mapView: GMSMapView!, markerInfoWindow marker: GMSMarker!) -> UIView! {
        marker.infoWindowAnchor = CGPointMake(0.44, 0.45)
        var view =  NSBundle.mainBundle().loadNibNamed("MapInfoWindow", owner:self, options:nil)[0] as! UIView
        //view.name.text = marker.title
        //view.distance.text = "\(dist) mi"
        //view.placeImage.image = [UIImage imageNamed:@"customPlaceImage"];
        //view.placeImage.transform = CGAffineTransformMakeRotation(-.08);
        return view;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }*/
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
