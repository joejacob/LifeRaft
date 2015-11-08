//
//  MapViewController.swift
//  LifeRaft
//
//  Created by Joe Jacob on 11/7/15.
//  Copyright © 2015 sbg11. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController, GMSMapViewDelegate {
    
    // group cannot exceed max of 100 people
    var markers = [GMSMarker?](count: 100, repeatedValue: nil)
    var groupMems = [Int: [String: String]]()   // list of people in group
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.cameraWithLatitude(-33.868, longitude:151.2086, zoom:6)
        var mapView = GMSMapView.mapWithFrame(self.view.bounds, camera:camera)
        mapView.delegate = self
        let numPeopleInGroup = 6 // number of people in the group
        var bounds = GMSCoordinateBounds() // coord bounds
        
        
        // updating from database
        var memberRef = myRootRef.childByAppendingPath("chat/group1/members")
        var uberRef = myRootRef.childByAppendingPath("chat/group1/ubers")
        
        
        // friend locations
        // TODO: the title of each marker will be the friend's initials
        let base = CLLocation(latitude: -33.868, longitude: 151.2086)
        for i in 0...(numPeopleInGroup-1) {
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
            m.snippet = "\(UIDevice.currentDevice().batteryLevel)"
            
            m.appearAnimation = kGMSMarkerAnimationPop
            m.map = mapView
            markers[i] = m
        }
        
        // updating bounds
        var camUpdate = GMSCameraUpdate.fitBounds(bounds, withPadding:30.0)
        mapView.moveCamera(camUpdate)
        self.view = mapView
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
