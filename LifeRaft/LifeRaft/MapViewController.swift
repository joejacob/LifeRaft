//
//  MapViewController.swift
//  LifeRaft
//
//  Created by Joe Jacob on 11/7/15.
//  Copyright © 2015 sbg11. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController, GMSMapViewDelegate, UIPopoverPresentationControllerDelegate {
    
    // group cannot exceed max of 100 people
    var markers = [GMSMarker?](count: 100, repeatedValue: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.cameraWithLatitude(-33.868,
            longitude:151.2086, zoom:6)
        var mapView = GMSMapView.mapWithFrame(self.view.bounds, camera:camera)
        mapView.delegate = self
        let numPeopleInGroup = 6 // number of people in the group
        var bounds = GMSCoordinateBounds() // coord bounds
        
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
            m.title = String(i)
            m.icon = UIImage(named: "smiley-face")
            
            // distance from current user
            let ccoord = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
            let dist = Double(round((ccoord.distanceFromLocation(base)/1000) * Double(0.62137) * 10)/10)
            m.snippet = String("\(dist) mi")
            
            m.appearAnimation = kGMSMarkerAnimationPop
            m.map = mapView
            markers[i] = m
        }
        
        // updating bounds
        var camUpdate = GMSCameraUpdate.fitBounds(bounds, withPadding:30.0)
        mapView.moveCamera(camUpdate)
        self.view = mapView
    }
    
    
    /*func mapView(mapView: GMSMapView!, markerInfoWindow marker: GMSMarker!) -> UIView {
        let popupWidth = UIScreen.mainScreen().bounds.width
        let contentWidth = 180
        let contentPad = 10
        let popupHeight = 140
        let popupBottomPadding = 16
        let popupContentHeight = popupHeight - popupBottomPadding
        
        var outerView = UIView(frame: CGRectMake(CGFloat(0), CGFloat(0), CGFloat(popupWidth), CGFloat(popupHeight)))
        
        var view = UIView(frame: CGRectMake(CGFloat(0), CGFloat(0), CGFloat(popupWidth), CGFloat(popupHeight)))
        view.backgroundColor = UIColor.whiteColor()
        
        var titleLabel = UILabel(frame: CGRectMake(CGFloat(contentPad), CGFloat(0), CGFloat(contentWidth), CGFloat(0)))
        titleLabel.font = UIFont(name: titleLabel.font.fontName, size:17.0)
        titleLabel.text = marker.title
        
        var descriptionLabel = UILabel(frame: CGRectMake(CGFloat(contentPad), CGFloat(24), CGFloat(contentWidth), CGFloat(20)))
        descriptionLabel.font = UIFont(name: descriptionLabel.font.fontName, size: 11.0)
        descriptionLabel.text = marker.snippet
        
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        
        return view
        
        
    }*/
    
    func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {
        
        
        //(mapVC, animated: true, completion: nil)
        
        return true
    }
    
    @IBAction func tapCallDirections(sender: UIButton) {
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
