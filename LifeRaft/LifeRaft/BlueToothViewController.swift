//
//  BlueToothViewController.swift
//  LifeRaft
//
//  Created by Grant Costa on 11/7/15.
//  Copyright © 2015 sbg11. All rights reserved.
//


import UIKit

class BlueToothViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var connectionsLabel: UILabel!
    
    @IBOutlet weak var memberTable: UITableView!
    
    var connections = [String]()
    
    let colorService = BluetoothManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorService.delegate = self
        memberTable.delegate = self
        memberTable.dataSource = self
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    
    func tableView(tableView:UITableView!, numberOfRowsInSection section:Int) -> Int
    {
        return connections.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!
    {
        
            let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "mycell")
            let newMember = connections[indexPath.row]
            //let join : UISwitch = UISwitch()
            //join.frame = CGRectMake(20, 20, 40, 20)
            
        
            
        
        
                cell.textLabel?.text="Name: \(newMember)"
                
        
                //cell.textLabel?.text = "Status: \(uber["status"]!!)"
                //cell.detailTextLabel?.text="Riders"
        
        
        
           // print("adding button")
                return cell
                //return cell
    }

 
}



extension BlueToothViewController : BluetoothManagerDelegate {
    
    func connectedDevicesChanged(manager: BluetoothManager, connectedDevices: [String]) {
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            self.connections = connectedDevices
            self.memberTable.reloadData()
            
        }
    }
    
    /*
    func colorChanged(manager: BluetoothManager, colorString: String) {
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            switch colorString {
            case "red":
                self.changeColor(UIColor.redColor())
            case "yellow":
                self.changeColor(UIColor.yellowColor())
            default:
                NSLog("%@", "Unknown color value received: \(colorString)")
            }
        }
    }*/
    
}