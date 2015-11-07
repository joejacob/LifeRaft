//
//  SendNotification.swift
//  LifeRaft
//
//  Created by Grant Costa on 11/7/15.
//  Copyright © 2015 sbg11. All rights reserved.
//

import Foundation
import UIKit

class SendNotification{
    
    func notify(localNotification:UILocalNotification,reason:String,note:String)->Void{
        localNotification.alertAction = reason
        localNotification.alertBody = note
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 1)
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
}