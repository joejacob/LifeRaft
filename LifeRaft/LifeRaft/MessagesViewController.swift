//
//  MessagesViewController.swift
//  LifeRaft
//
//  Created by Sam Ginsburg on 11/7/15.
//  Copyright © 2015 sbg11. All rights reserved.
//

import UIKit

class MessagesViewController: UIViewController {

    
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) { // became first responder
        
        //move textfields up
        let myScreenRect: CGRect = UIScreen.mainScreen().bounds
        let keyboardHeight : CGFloat = 216
        
        UIView.beginAnimations( "animateView", context: nil)
        var movementDuration:NSTimeInterval = 0.35
        var needToMove: CGFloat = 0
        
        var frame : CGRect = self.view.frame
        if (textField.frame.origin.y + textField.frame.size.height + /*self.navigationController.navigationBar.frame.size.height + */UIApplication.sharedApplication().statusBarFrame.size.height > (myScreenRect.size.height - keyboardHeight)) {
            needToMove = (textField.frame.origin.y + textField.frame.size.height + /*self.navigationController.navigationBar.frame.size.height +*/ UIApplication.sharedApplication().statusBarFrame.size.height) - (myScreenRect.size.height - keyboardHeight);
        }
        
        frame.origin.y -= needToMove
        self.view.frame = frame
        UIView.commitAnimations()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        //move textfields back down
        UIView.beginAnimations( "animateView", context: nil)
        var movementDuration:NSTimeInterval = 0.35
        var frame : CGRect = self.view.frame
        frame.origin.y = 0
        self.view.frame = frame
        UIView.commitAnimations()
    }
    
    func keyboardWillShow(notification:NSNotification) {
        adjustingHeight(true, notification: notification)
    }
    
    func keyboardWillHide(notification:NSNotification) {
        adjustingHeight(false, notification: notification)
    }

    func adjustingHeight(show:Bool, notification:NSNotification) {
         1
        var userInfo = notification.userInfo!
         2
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
         3
        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
         4
        let changeInHeight = (CGRectGetHeight(keyboardFrame)) * (show ? 1 : -1)
        5
        UIView.animateWithDuration(animationDurarion, animations: { () -> Void in
            self.bottomConstraint.constant += changeInHeight
        })
        
    }
    
    
    /*func keyboardWillShow(notification: NSNotification) {
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
