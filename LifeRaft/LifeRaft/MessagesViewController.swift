//
//  MessagesViewController.swift
//  LifeRaft
//
//  Created by Sam Ginsburg on 11/7/15.
//  Copyright © 2015 sbg11. All rights reserved.
//

import UIKit

class MessagesViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
    }
    @IBOutlet weak var bottomCons: NSLayoutConstraint!
    
    
    func keyboardWillShow(sender: NSNotification) {
        let info:NSDictionary = sender.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        bottomCons!.constant = keyboardSize.height
    }
    func keyboardWillHide(sender: NSNotification) {
        bottomCons!.constant = 8
    }    /*func keyboardWillShow(notification: NSNotification) {
        let info:NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        
        let keyboardHeight: CGFloat = keyboardSize.height
        
        let _: CGFloat = info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber as CGFloat
        
        
        UIView.animateWithDuration(0.1, delay: 0.1, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.view.frame = CGRectMake(0, (self.view.frame.origin.y - keyboardHeight), self.view.bounds.width, self.view.bounds.height)
            }, completion: nil)
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let info: NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        
        let keyboardHeight: CGFloat = keyboardSize.height
        
        let _: CGFloat = info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber as CGFloat
        
        UIView.animateWithDuration(0.1, delay: 0.1, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.view.frame = CGRectMake(0, (self.view.frame.origin.y + keyboardHeight), self.view.bounds.width, self.view.bounds.height)
            }, completion: nil)
        
    }*/
    
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
