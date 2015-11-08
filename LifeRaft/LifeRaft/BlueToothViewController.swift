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
    
    let blueTooth = BluetoothManager()
    
    
    @IBAction func cancelClicked(sender: UIButton) {
        connections.removeAll()
        self.dismissViewControllerAnimated(true, completion: {});
        
    }
    @IBAction func doneClicked(sender: UIButton) {
        if connections.count > 0 {
            //store connections in database
            connections.removeAll()
            self.dismissViewControllerAnimated(true, completion: {});
        }
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return connections.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
            let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "mycell")
            let newMember = connections[indexPath.row]
            cell.textLabel?.text="Name: \(newMember)"
            return cell
    }

 
}



extension BlueToothViewController : BluetoothManagerDelegate {
    
    func connectedDevicesChanged(manager: BluetoothManager, connectedDevices: [String]) {
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            self.connections = connectedDevices
            self.memberTable.reloadData()
        }
    }
}