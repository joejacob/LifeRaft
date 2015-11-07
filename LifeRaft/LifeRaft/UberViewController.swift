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

class UberViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet var uberTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let parameters = ["start_latitude": "35.9998010", "start_longitude": "-78.9398990", "server_token": "IkeP15gQ1R4pA5NCoYsH8wUEqYuctmf5odY9p4j0"]
        
        Alamofire.request(.GET, "https://api.uber.com/v1/estimates/time", parameters: parameters)//, encoding: .JSON, headers: headers)
            
            .responseJSON{ response in
                print(response.request)
                
                print(response.response)
                print(response.data)
                print(response.result)
                
               /* if let value = response.result.value{
                    let valueJson = JSON(value)
                    for result in valueJson["times"].arrayValue{
                        print("Uber type: \(result["display_name"].string!)")
                        print("Estimate: \(result["estimate"].int!/60) minutes")
                    }
                }*/
        }
        uberTable.dataSource = self
        uberTable.delegate = self
    }
        // Do any additional setup after loading the view.
    
func numberOfSectionsInTableView(tableView: UITableView) -> Int{return 1}
func tableView(tableView:UITableView!, numberOfRowsInSection section:Int) -> Int
{
    return 20
}

func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!
{
    let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "mycell")
    cell.textLabel!.text="row#\(indexPath.row)"
    cell.detailTextLabel!.text="subtitle#\(indexPath.row)"
    
    return cell
}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func getUber(sender: UIButton) {
    
    //"server_token": "IkeP15gQ1R4pA5NCoYsH8wUEqYuctmf5odY9p4j0",
    //let parameters = ["product_id" : "7f4c7355-03db-4d78-8fba-63ac4813ad77", "start_latitude" : 35.9998010, "start_longitude" : -78.9398990, "end_latitude" : 34.9998010, "end_longitude" : -79.0000000]
    //
        let parameters = ["start_latitude": "35.9998010", "start_longitude": "-78.9398990", "server_token": "IkeP15gQ1R4pA5NCoYsH8wUEqYuctmf5odY9p4j0"]
    //get available Ubers
    /*
    Alamofire.request(.GET, "https://api.uber.com/v1/products", parameters: parameters)
    let parameters = ["latitude": "35.9998010", "longitude": "-78.9398990", "server_token": "IkeP15gQ1R4pA5NCoYsH8wUEqYuctmf5odY9p4j0"]
    */
        let headers = ["Authorization": "Bearer blSLfPsmxbbwfvDiGxnHKtNgpZLy8g"]
    //let parameters = ["request_id" : "e06cf0d4-fbe4-4569-b543-449bdfc8edd7"]
    // let headers = JSON(["Authorization":"Bearer blSLfPsmxbbwfvDiGxnHKtNgpZLy8g"])
    //Alamofire.request(.DELETE, parameters  : parameters, encoding: .JSON, headers: headers)
        
        Alamofire.request(.GET, "https://api.uber.com/v1/estimates/time", parameters: parameters)//, encoding: .JSON, headers: headers)
    
            .responseJSON{ response in
                print(response.request)
    
                print(response.response)
                print(response.data)
                print(response.result)
    
                if let value = response.result.value{
                    let valueJson = JSON(value)
                    for result in valueJson["times"].arrayValue{
                        print("Uber type: \(result["display_name"].string!)")
                        print("Estimate: \(result["estimate"].int!/60) minutes")
    
    //                    if let products = valueJson["products"].string{
    //                        print("The products are " + products)
    //                    }
    //                    else{
    //                        print("No available products")
    //                    }
                        print(result)
                    }
                    print("JSON: \(value)")
    
    //JSON.
                }
        }

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
