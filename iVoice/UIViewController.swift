//
//  UIViewController.swift
//  iVoice
//
//  Created by  jianhao on 2016/4/24.
//  Copyright © 2016年 cocoaSwifty. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func alertSingle(title: String, message: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    func alertSelectable(title: String = "", message: String, isYes: Bool, isNo: Bool, isCacel: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        if isYes {
            alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (alertAction: UIAlertAction!) -> Void in
                debugPrint("You Pressed Yes")
                //doSomething 還需要修改...
            }))
        }
        
        if isNo {
            alert.addAction(UIAlertAction(title: "No", style: .Default, handler: { (alertAction: UIAlertAction!) -> Void in
                debugPrint("You Pressed No")
                //doSomething
            }))
        }
        
        if isCacel {
            alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (alertAction: UIAlertAction!) -> Void in
                debugPrint("You Pressed Cancel")
                //doSomething
            }))
        }
        
        self.presentViewController(alert, animated: true) { () -> Void in
            debugPrint("This will be executed when the alert view is presented to the screen")
        }
        
    }
    
}

