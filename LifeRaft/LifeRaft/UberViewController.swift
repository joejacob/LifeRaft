//
//  UberViewController.swift
//  LifeRaft
//
//  Created by Michael Schroeder on 11/7/15.
//  Copyright © 2015 sbg11. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
//import CoreLocation

class UberViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet var uberTable: UITableView!
    @IBOutlet var uberETA: UILabel!
    
    var currentUbers = Array<[String:String?]>()
    var nextUber = [String]()
    var uberToGet : String = ""
   // let locationManager = CLLocationManager()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Ask for Authorisation from the User.
//        self.locationManager.requestAlwaysAuthorization()
//        
//        // For use in foreground
//        self.locationManager.requestWhenInUseAuthorization()
//        
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//            locationManager.startUpdatingLocation()
//        }
        let parameters = ["start_latitude": "35.9998010", "start_longitude": "-78.9398990", "server_token": "IkeP15gQ1R4pA5NCoYsH8wUEqYuctmf5odY9p4j0"]
        
        Alamofire.request(.GET, "https://api.uber.com/v1/estimates/time", parameters: parameters)//, encoding: .JSON, headers: headers)
            
            .responseJSON{ response in
                print(response.request)
                
                print(response.response)
                print(response.data)
                print(response.result)
                
               if let value = response.result.value{
                    let valueJson = JSON(value)
                    for result in valueJson["times"].arrayValue{
                        if result["display_name"].string!=="uberX"{
                            self.uberETA.text!+="\(result["estimate"].int!/60) minutes"
                            self.uberToGet = result["product_id"].string!
                        }
                        print("Uber type: \(result["display_name"].string!)")
                        print("Estimate: \(result["estimate"].int!/60) minutes")
                    }
                }
        }
        uberTable.dataSource = self
        uberTable.delegate = self
    }
        // Do any additional setup after loading the view.
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView:UITableView!, numberOfRowsInSection section:Int) -> Int
    {
        return currentUbers.count
    }

    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!
    {
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "mycell")
        let uber = currentUbers[indexPath.row]
        cell.textLabel?.text="ETA: \(uber["eta"])  Driver name: \(uber["driver name"])"
        cell.detailTextLabel!.text="subtitle#\(indexPath.row)"
    
        return cell
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func callUber(){
        let parameters : [String:AnyObject] = ["product_id" : uberToGet , "start_latitude" : 35.9998010, "start_longitude" : -78.9398990, "end_latitude" : 34.9998010, "end_longitude" : -79.0000000]
        //
        //let parameters = ["start_latitude": "35.9998010", "start_longitude": "-78.9398990", "server_token": "IkeP15gQ1R4pA5NCoYsH8wUEqYuctmf5odY9p4j0"]
        //get available Ubers
        /*
        Alamofire.request(.GET, "https://api.uber.com/v1/products", parameters: parameters)
        let parameters = ["latitude": "35.9998010", "longitude": "-78.9398990", "server_token": "IkeP15gQ1R4pA5NCoYsH8wUEqYuctmf5odY9p4j0"]
        */
        let headers = ["Authorization": "Bearer blSLfPsmxbbwfvDiGxnHKtNgpZLy8g"]
        //let parameters = ["request_id" : "e06cf0d4-fbe4-4569-b543-449bdfc8edd7"]
        // let headers = JSON(["Authorization":"Bearer blSLfPsmxbbwfvDiGxnHKtNgpZLy8g"])
        //Alamofire.request(.DELETE, parameters  : parameters, encoding: .JSON, headers: headers)
        var currentRequest = ""
        Alamofire.request(.POST, "https://sandbox-api.uber.com/v1/requests", parameters: parameters, encoding: .JSON, headers: headers)
            
            .responseJSON{ response in
                print(response.request)
                
                print(response.response)
                print(response.data)
                print(response.result)
                
                if let value = response.result.value{
                    print(value)
                    let valueJson = JSON(value)
                    currentRequest = valueJson["request_id"].string!
                    //self.uberETA.text = "ETA: \(valueJson["eta"].string!)"
                    
                    
                    
                    
                    
                    //                    if let products = valueJson["products"].string{
                    //                        print("The products are " + products)
                    //                    }
                    //                    else{
                    //                        print("No available products")
                    //                    }
                    
                self.requestInfo(currentRequest, headers: headers)
                }
                //self.currentUbers.append(<#T##newElement: Array<String>##Array<String>#>)
                
                
                //JSON.
        }
        //wait(w_status: 30)
        //return (currentRequest, headers)
        
        
    }
    //print("end")
    


   

    @IBAction func getUber(sender: UIButton) {
    
    //"server_token": "IkeP15gQ1R4pA5NCoYsH8wUEqYuctmf5odY9p4j0",
            //let (request, headers) = callUber()
        
            //requestInfo(request, headers:headers)
        self.callUber()
        
        }
    
    func requestInfo(currentRequest: String, headers:[String:String])->String{
        var requestDetails : [String: AnyObject] = ["request_id":currentRequest]
        Alamofire.request(.GET, "https://sandbox-api.uber.com/v1/requests/\(currentRequest)", encoding: .JSON, headers: headers)
            
            .responseJSON{ response in
                
                print("Current request id: \(currentRequest)")
                print(response.request)
                print(response.response)
                print(response.data)
                print(response.result)
                if let value = response.result.value{
                    print(value)
                    let json = JSON(value)
                    var uberInfo : [String: String?]
                    uberInfo = ["eta":json["eta"].string, "driver name":json["driver"]["name"].string]
                    //"latitude":json["location"]["latitude"].float.description
                    self.currentUbers.append(uberInfo)
                    self.uberTable.reloadData()
                    print("current ubers \(self.currentUbers)")
                   
                }
        }
        return currentRequest
    
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
