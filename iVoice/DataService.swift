//
//  DataService.swift
//  iVoice
//
//  Created by  jianhao on 2016/4/24.
//  Copyright © 2016年 cocoaSwifty. All rights reserved.
//

import Foundation
import Firebase

//DataService 類別是一個專門和 Firebase 打交道的服務類別。
//要讀寫數據，需要利用 Firebase URL 建立 Firebase 參考數據庫。
//稍後我們會把 users 和 jokes 以子節點的形式保存。
class DataService {
    static let dataService = DataService()
    
    private var _BASE_REF = Firebase(url: "\(BASE_URL)")
    private var _USER_REF = Firebase(url: "\(BASE_URL)/users")
    private var _JOKE_REF = Firebase(url: "\(BASE_URL)/jokes")
    
    var BASE_REF: Firebase {return _BASE_REF}
    
    var USER_REF: Firebase {return _USER_REF}
    
    var CURRENT_USER_REF: Firebase {
        let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
        
        let currentUser = Firebase(url: "\(BASE_REF)").childByAppendingPath("users").childByAppendingPath(userID)
        
        return currentUser!
    }
    
    var JOKE_REF: Firebase {
        return _JOKE_REF
    }
    
    func createNewAccount(uid: String, user: Dictionary<String, String>) {
        
        // A User is born.  //保存用戶資料
        
        USER_REF.childByAppendingPath(uid).setValue(user)
    }
    
    func createNewJoke(joke: Dictionary<String, AnyObject>) {
        
        // Save the Joke
        // JOKE_REF is the parent of the new Joke: "jokes".
        // childByAutoId() saves the joke and gives it its own ID.
        
        let firebaseNewJoke = JOKE_REF.childByAutoId()
        
        // setValue() saves to Firebase.
        
        firebaseNewJoke.setValue(joke)
    }
}