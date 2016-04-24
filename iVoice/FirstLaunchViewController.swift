//
//  FirstLaunchViewController.swift
//  iVoice
//
//  Created by jianhao on 2016/4/25.
//  Copyright © 2016年 cocoaSwifty. All rights reserved.
//

import UIKit
import Firebase

class FirstLaunchViewController: UIViewController {

    @IBOutlet weak var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmButton.hidden = true
        
        //註冊Uid
        CreateUid().createUid { error, data in
            //確保不存在error
            guard error == nil else {self.alertSingle("系統忙碌中，請稍候重新嘗試");return}

            //註冊成功，把拿到的uid存起來
            NSUserDefaults.standardUserDefaults().setValue(data.uid, forKey: "uid")
            print("到期", data.expires)
            self.confirmButton.hidden = false
            
        }

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func confirmButtonPressed(sender: UIButton) {
        
        self.performSegueWithIdentifier("ToChat", sender: nil)
    }

}
