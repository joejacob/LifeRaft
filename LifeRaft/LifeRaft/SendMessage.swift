//
//  SendMessage.swift
//  LifeRaft
//
//  Created by Grant Costa on 11/7/15.
//  Copyright © 2015 sbg11. All rights reserved.
//

import Foundation
import Alamofire


class SendMessage {
    
    func text(phoneNumbers:Array<String>,message:String){
        for s in phoneNumbers{
            let data = [
                "To" : s,
                "From" : "+15162170165",
                "Body" : message as String
            ]
            let live_sid = "ACaf894cc19d677198cf21bcd7a53f09cc"
            let live_auth_token = "d32e8ad010f4a75049eb4488527aa814"
            Alamofire.request(.POST, "https://api.twilio.com/2010-04-01/Accounts/\(live_sid)/Messages" ,parameters: data)
                .authenticate(user: live_sid, password: live_auth_token)
                .responseJSON { response in
                    print(response.request)
                    //print(response.response)
                    //print(response.result)
            }
        }
    }
}