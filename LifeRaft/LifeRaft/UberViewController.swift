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
import Firebase

//import CoreLocation

class UberViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet var uberTable: UITableView!
    @IBOutlet var uberETA: UILabel!
    
    var currentUbers = Array<[String:String?]>()
    var nextUber = [String]()
    var uberToGet : String = ""
    var myHeader = ["Authorization": "Bearer blSLfPsmxbbwfvDiGxnHKtNgpZLy8g"]
    var buttonArray = [UIButton]()
    var infoArray = [UIButton]()
   // let locationManager = CLLocationManager()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uberTable.allowsSelection = false
        uberTable.separatorStyle = UITableViewCellSeparatorStyle.None
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
        
      
        getClosestUber()
        uberTable.dataSource = self
        uberTable.delegate = self
        for var u in currentUbers{
            requestInfo(u["request"]!!,add:false)
        }
//        for var u in currentUbers{
//            updateUberStatus(u["request"]!!, status: "processing")
//        }
        
    }
    override func viewDidAppear(animated: Bool) {
        var i = 0
        for var u in currentUbers{
            print("should make the status processs")
            updateUberStatus(u["request"]!!, status: "accepted", index: i)
            i++
        }
        
        for var u in currentUbers{
            requestInfo(u["request"]!!,add:false)
        }

        
        self.uberTable.reloadData()

    }
    /*override func performSegueWithIdentifier(identifier: String, sender: AnyObject?) {
        if identifier == "WEB_VIEW"{
            let destinationVC = identifier destinationViewController as! WebViewController
            //destinationVC.textInput = sender
        }

    }*/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //if segue.identifier == "WEB_VIEW"{
            let destinationVC = segue.destinationViewController as! MapViewController
            //destinationVC.textInput = sender?.currentTitle
       //performSegueWithIdentifier(
        
       // }
               // map.delegate = self
        
    }
        // Do any additional setup after loading the view.
    func updateUberStatus(requestNum : String, status : String, index: Int){
        var stat = ["status": status]
        Alamofire.request(.PUT, "https://sandbox-api.uber.com/v1/sandbox/requests/\(requestNum)", parameters: stat, encoding: .JSON, headers: myHeader)
        currentUbers[0]["status"]=status
        
    }
    
    func getClosestUber(){
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
                            self.uberETA.text!="ETA: \(result["estimate"].int!/60) minutes"
                            self.uberToGet = result["product_id"].string!
                        }
                        print("Uber type: \(result["display_name"].string!)")
                        print("Estimate: \(result["estimate"].int!/60) minutes")
                    }
                }
                
                print("****UBER TO get \(self.uberToGet)")
        }

    }
    func infoClicked(sender: UIButton!){
        
        performSegueWithIdentifier("map", sender: sender)
    }
    func buttonClicked(sender: UIButton!){
        print("joined uber")
        let rgbValue = 0x4863a0
        let r = CGFloat((rgbValue & 0xFF0000) >> 16)/255.0
        let g = CGFloat((rgbValue & 0xFF00) >> 8)/255.0
        let b = CGFloat((rgbValue & 0xFF))/255.0
        var status : String? = "join"
        if !sender.selected {
            sender.selected = true
            
            sender.setTitle("leave", forState: UIControlState.Selected)
            sender.setTitleColor(UIColor.redColor(), forState: UIControlState.Selected)
            sender.backgroundColor = UIColor(red:r, green: g, blue: b, alpha: 1.0)
            //sender.
            //sender.backgroundColor = UIColo
            //nder.setOn(true, animated: true)
            //sender.setOn(true, animated: true)
            currentUbers[sender.tag]["riders"]!! += " name"
            var i:Int? = Int(currentUbers[sender.tag]["open spots"]!!)
            i!--
            currentUbers[sender.tag]["open spots"] = "\(i!)"
            self.uberTable.reloadData()
        }
        else{
            //sender.setOn(false, animated:true)
            sender.selected = false
            sender.backgroundColor = UIColor(red:r, green: g, blue: b, alpha: 1.0)
             sender.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
            sender.setTitle("join", forState: UIControlState.Normal)
        currentUbers[sender.tag]["riders"]!! = currentUbers[sender.tag]["riders"]!!.stringByReplacingOccurrencesOfString(" name", withString: "")
        var i:Int? = Int(currentUbers[sender.tag]["open spots"]!!)
        i!++
        currentUbers[sender.tag]["open spots"] = "\(i!)"
        self.uberTable.reloadData()
        }
    }
    
    
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
        let rgbValue = 0x4863a0
        let r = CGFloat((rgbValue & 0xFF0000) >> 16)/255.0
        let g = CGFloat((rgbValue & 0xFF00) >> 8)/255.0
        let b = CGFloat((rgbValue & 0xFF))/255.0
        if(indexPath.row>buttonArray.count-1){
            print("\(indexPath.row) is greater than \(buttonArray.count-1)")
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "mycell")
        let uber = currentUbers[indexPath.row]
        //let join : UISwitch = UISwitch()
        //join.frame = CGRectMake(20, 20, 40, 20)
            
            cell.backgroundColor = UIColor(red:r, green: g, blue: b, alpha: 1.0)
            let uberMap : UIButton = UIButton(type: UIButtonType.InfoLight)
            uberMap.setTitle("\(uber["map"]!!)", forState: UIControlState.Normal)
            uberMap.frame = CGRectMake(20,20,20,20)
            uberMap.addTarget(self, action: "infoClicked:",  forControlEvents: UIControlEvents.TouchUpInside)
            //uberMap.setValue(uber["map"]!!, forUndefinedKey: "url")
            //uberMap.se
        let button : UIButton = UIButton(type: UIButtonType.Custom) as UIButton
        button.frame = CGRectMake(20, 20, 80, 20)
            //cell.backgroundColor = UIColor.blueColor()
        let cellHeight: CGFloat = 110.0
            uberMap.center=CGPoint(x:view.bounds.width/2.0, y:cellHeight/2.0)
        //join.center = CGPoint(x: view.bounds.width - 60, y:cellHeight/2.0)
            uberMap.backgroundColor = UIColor.whiteColor()
            cell.addSubview(uberMap)
        infoArray.append(uberMap)
            //join.addTarget(self, action: "buttonClicked:", forControlEvents:  UIControlEvents.ValueChanged)
       button.center = CGPoint(x: view.bounds.width - 100, y:cellHeight/2.0)
        button.addTarget(self, action: "buttonClicked:", forControlEvents:  UIControlEvents.TouchUpInside)
            
        button.tag = indexPath.row
            button.backgroundColor = UIColor(red:r, green: g, blue: b, alpha: 1.0)
            //button.titleLabel?.
        //join.tag = indexPath.row
        //join.setOn(false, animated:true)
       // button.t
        button.setTitle("join", forState: UIControlState.Normal)
            button.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
        if uber["status"]! == "accepted"{
        cell.textLabel?.text="ETA: \(uber["eta"]!!)"
            cell.textLabel?.textColor = UIColor.whiteColor()
            cell.backgroundColor = UIColor(red:r, green: g, blue: b, alpha: 1.0)
        
        }
        else{
            cell.textLabel?.text = "Status: \(uber["status"]!!)"
            cell.textLabel?.textColor = UIColor.whiteColor()
            //cell.detailTextLabel?.text="Riders"
        }
        cell.detailTextLabel?.text="Riders \(uber["riders"]!!) Open Spots: \(uber["open spots"]!!)"
        cell.detailTextLabel?.textColor = UIColor.whiteColor()
        cell.addSubview(button)
            print("adding button")
        buttonArray.append(button)
            return cell
        }
        else{
            let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "mycell")
            let uber = currentUbers[indexPath.row]
            cell.backgroundColor = UIColor(red:r, green: g, blue: b, alpha: 1.0)
            print("row \(indexPath.row) and button \(buttonArray.count)")
            //let join : UISwitch = UISwitch()
            //join.frame = CGRectMake(20, 20, 40, 20)
            /*
            let button : UIButton = UIButton(type: UIButtonType.ContactAdd) as UIButton
            button.frame = CGRectMake(20, 20, 20, 20)
            let cellHeight: CGFloat = 110.0v
            //join.center = CGPoint(x: view.bounds.width - 60, y:cellHeight/2.0)
            //join.addTarget(self, action: "buttonClicked:", forControlEvents:  UIControlEvents.ValueChanged)
            button.center = CGPoint(x: view.bounds.width - 45, y:cellHeight/2.0)
            button.addTarget(self, action: "buttonClicked:", forControlEvents:  UIControlEvents.TouchUpInside)
            button.tag = indexPath.row
            //join.tag = indexPath.row
            //join.setOn(false, animated:true)
            // button.t
            button.setTitle("join", forState: UIControlState.Normal)
*/          let button = buttonArray[indexPath.row]
            let info = infoArray[indexPath.row]
            print("\(button.state)")
            if uber["status"]! == "accepted"{
                cell.textLabel?.text="ETA: \(uber["eta"]!!)"
                cell.textLabel?.textColor = UIColor.whiteColor()
                cell.backgroundColor = UIColor(red:r, green: g, blue: b, alpha: 1.0)
            }
            else{
                cell.textLabel?.text = "Status: \(uber["status"]!!)"
                cell.textLabel?.textColor = UIColor.whiteColor()
                //cell.detailTextLabel?.text="Riders"
            }
            cell.detailTextLabel?.text="Riders \(uber["riders"]!!) Open Spots: \(uber["open spots"]!!)"
            cell.detailTextLabel?.textColor = UIColor.whiteColor()
            cell.addSubview(info)
            cell.addSubview(button)
            //buttonArray.append(button)
            return cell
        }
        
        //return cell
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
        //let headers = ["Authorization": "Bearer blSLfPsmxbbwfvDiGxnHKtNgpZLy8g"]
        //let parameters = ["request_id" : "e06cf0d4-fbe4-4569-b543-449bdfc8edd7"]
        // let headers = JSON(["Authorization":"Bearer blSLfPsmxbbwfvDiGxnHKtNgpZLy8g"])
        //Alamofire.request(.DELETE, parameters  : parameters, encoding: .JSON, headers: headers)
        var currentRequest = ""
        Alamofire.request(.POST, "https://sandbox-api.uber.com/v1/requests", parameters: parameters, encoding: .JSON, headers: myHeader)
            
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
                    
                    self.requestInfo(currentRequest, add:true)
                }
                //self.currentUbers.append(<#T##newElement: Array<String>##Array<String>#>)
                
                
                //JSON.
        }
        //wait(w_status: 30)
        //return (currentRequest, headers)
        
        getClosestUber()
    }
    //print("end")
    


   

    @IBAction func getUber(sender: UIButton) {
    
    //"server_token": "IkeP15gQ1R4pA5NCoYsH8wUEqYuctmf5odY9p4j0",
            //let (request, headers) = callUber()
        
            //requestInfo(request, headers:headers)
        self.callUber()
        
        }
    
    func requestInfo(currentRequest: String, add : Bool)->String{
        var requestDetails : [String: AnyObject] = ["request_id":currentRequest]
        var mapLink : String = ""
        Alamofire.request(.GET, "https://sandbox-api.uber.com/v1/requests/\(currentRequest)/map", encoding: .JSON, headers: myHeader)
            .responseJSON{ response in
                if let value = response.result.value{
                    let json = JSON(value)
                    print(json)
                    mapLink = json["href"].string!
                    
                }
        }
        Alamofire.request(.GET, "https://sandbox-api.uber.com/v1/requests/\(currentRequest)", encoding: .JSON, headers: myHeader)
            
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
                    uberInfo = ["eta":"\(json["eta"].int!)", "driver name":json["driver"]["name"].string,"riders":"","request":currentRequest, "status":json["status"].string,"open spots":"\(3)", "latitude":"\(json["location"]["latitude"])","longitude":"\(json["location"]["longitude"])","map":"\(mapLink)"]
                    //"latitude":json["location"]["latitude"].float.description
                    if add{
                    self.currentUbers.append(uberInfo)
                    }
                    else{
                        self.currentUbers.removeLast()
                        self.currentUbers.append(uberInfo)
                        
                    }
                    
                    self.uberTable.reloadData()
                    
                    print("current ubers \(self.currentUbers)")
                   
                }
        }
        getClosestUber()
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
