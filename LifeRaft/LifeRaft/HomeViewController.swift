//
//  HomeViewController.swift
//  LifeRaft
//
//  Created by Sam Ginsburg on 11/7/15.
//  Copyright © 2015 sbg11. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import FBSDKCoreKit
import FBSDKShareKit

private let reuseIdentifier = "Cell"
private let cellReuseIdentifier = "RaftmateCell"
private let titleReuseIdentifier = "RaftTitle"
private let sectionInsets = UIEdgeInsets(top: 20.0, left: 5.0, bottom: 20.0, right: 5.0)
private let arRef = myRootRef.childByAppendingPath("chat/group1")
var myAuth : FAuthData = FAuthData()
var myUid : String = ""
var myFullName : String = ""
var myProfImgLink : String = ""
var loggedin = false

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    var members = [ String : [String : String]]()
    var memKeys = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var notRef = myRootRef.childByAppendingPath("notification")
        notRef.observeEventType(FEventType.Value, withBlock: { snapshot in
            print(snapshot.value)
            let note = UILocalNotification()
            let no = SendNotification()
            no.notify(note, reason: "", note: snapshot.value as! String)
        })

        // Do any additional setup after loading the view.
        
        var membersRef = myRootRef.childByAppendingPath("group1/members")
        membersRef.observeEventType(FEventType.ChildAdded, withBlock: { snapshot in
            print(snapshot.value)
            print(snapshot.key)
            print("cat")
            var newUid = snapshot.key!
            print("dog")
            if let newMember = snapshot.value as? [String: String] {
            
                let ok = self.members[newUid] == nil
                self.members[newUid] = newMember
                print(newMember)
                print(newUid)
                print (self.members[newUid])
                    print("HELLO")
                    self.memKeys.append(newUid)
                    self.myCollectionView.reloadData()
                    self.myCollectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.myCollectionView.reloadData()
                })
            }
//            print(snapshot.value.objectForKey("author"))
//            print(snapshot.value.objectForKey("title"))
        })
        
        // Register cell classes
//        self.myCollectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
//        let ref = Firebase(url: "https://dazzling-inferno-3224.firebaseio.com/")
//        let facebookLogin = FBSDKLoginManager()
//        
//        print("WOOOOOOO")
//        
//        facebookLogin.logInWithReadPermissions(["email"], fromViewController: self, handler: {
//            (facebookResult, facebookError) -> Void in
//            
//            print("TESTTTTTTT")
//            if facebookError != nil {
//                print("Facebook login failed. Error \(facebookError)")
//            } else if facebookResult.isCancelled {
//                print("Facebook login was cancelled.")
//            } else {
//                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
//                
//                ref.authWithOAuthProvider("facebook", token: accessToken,
//                    withCompletionBlock: { error, authData in
//                        
//                        if error != nil {
//                            print("Login failed. \(error)")
//                        } else {
//                            print("Logged in! \(authData)")
//                            myAuth = authData
//                        }
//                })
//            }
//        })
//        facebookLogin.logInWithReadPermissions(["email"], handler: {
//            (facebookResult, facebookError) -> Void in
//            
//            print("TESTTTTTTT")
//            if facebookError != nil {
//                print("Facebook login failed. Error \(facebookError)")
//            } else if facebookResult.isCancelled {
//                print("Facebook login was cancelled.")
//            } else {
//                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
//                
//                ref.authWithOAuthProvider("facebook", token: accessToken,
//                    withCompletionBlock: { error, authData in
//                        
//                        if error != nil {
//                            print("Login failed. \(error)")
//                        } else {
//                            print("Logged in! \(authData)")
//                            myAuth = authData
//                        }
//                })
//            }
//        })
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
        let ref = Firebase(url: "https://dazzling-inferno-3224.firebaseio.com/")
        let facebookLogin = FBSDKLoginManager()
        
        if ref.authData != nil {
            var authData = ref.authData
            print("Logged in! \(authData)")
            myAuth = authData
            myUid = authData.uid
            myFullName = (authData.providerData["displayName"] as? NSString as? String)!
            myProfImgLink = (authData.providerData["profileImageURL"] as? NSString as? String)!
            loggedin = true
        } else {
        
        facebookLogin.logInWithReadPermissions(["email"], fromViewController: self, handler: {
            (facebookResult, facebookError) -> Void in
            
            if facebookError != nil {
                print("Facebook login failed. Error \(facebookError)")
            } else if facebookResult.isCancelled {
                print("Facebook login was cancelled.")
            } else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                
                ref.authWithOAuthProvider("facebook", token: accessToken,
                    withCompletionBlock: { error, authData in
                        
                        if error != nil {
                            print("Login failed. \(error)")
                        } else {
                            print("Logged in! \(authData)")
                            myAuth = authData
                            myUid = authData.uid
                            myFullName = (authData.providerData["displayName"] as? NSString as? String)!
                            myProfImgLink = (authData.providerData["profileImageURL"] as? NSString as? String)!
                            loggedin = true
                            
                            
                            var userRef = ref.childByAppendingPath("users/\(myUid)")
                            let newUser = [
                                "fullName": myFullName,
                                "profImgLink": myProfImgLink
                            ]
                            userRef.setValue(newUser)
                            
                        }
                })
            }
        })
        }
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
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        print(self.members.count)
        return self.members.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseIdentifier, forIndexPath: indexPath) as! MemberCollectionViewCell
        
//        cell.backgroundColor = UIColor.blackColor()
//        var memValDict = self.members.indexForKey()
        var myCurKey = self.memKeys[indexPath.row]
        var valDict = self.members[myCurKey]
        cell.myNameLabel.text = valDict!["Name"]!
        cell.myBatteryView.text = valDict!["Battery"]
        cell.myDistanceLabel.text = valDict!["Status"]
        let url = NSURL(string: valDict!["URL"]!)
        let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
        var image = UIImage(data: data!)
        cell.myImageView.image = image
//        cell.myImageView = ""
        //cell.myStatusLabel.text = "OK"

        
        // Configure the cell
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    /*
    Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
    }
    */
    
    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
    }
    */
    
    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return false
    }
    
    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
    return false
    }
    
    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 160, height: 150)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

}
