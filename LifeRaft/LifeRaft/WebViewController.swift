//
//  WebViewController.swift
//  LifeRaft
//
//  Created by Michael Schroeder on 11/8/15.
//  Copyright © 2015 sbg11. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    var textInput: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.textInput != nil{
            let url = NSURL(string: textInput!)
            let urlRequest = NSURLRequest(URL: url!)
            webView.loadRequest(urlRequest)
        }
        // Do any additional setup after loading the view.
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
