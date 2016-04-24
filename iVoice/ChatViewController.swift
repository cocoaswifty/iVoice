//
//  ChatViewController.swift
//  iVoice
//
//  Created by jianhao on 2016/4/24.
//  Copyright © 2016年 cocoaSwifty. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    var senderId = ""
    let rootRef = Firebase(url: BASE_URL)
    var messageRef: Firebase!
    
    var userIsTypingRef: Firebase! // 1 一個 Firebase 引用，用於存儲當前用戶是否正在輸入。
    private var localTyping = false // 2 一個私有屬性，用於記錄當前用戶是否正在輸入。
    var isTyping: Bool {
        get {
            return localTyping
        }
        set {
            // 3 一個計算屬性，通過簡單地給這個屬性賦值，就可以實時修改 userIsTypingRef。
            localTyping = newValue
            userIsTypingRef.setValue(newValue)
        }
    }
    var usersTypingQuery: FQuery!   //這個屬性是一個 FQuery，跟 Firebase 引用一樣，只不過它是排序的。
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        senderId = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
        //初始化 messageRef：這個方法可用於創建下級引用。
        //所有的引用其實可以共享同一個 Firebase 數據庫連接。
        messageRef = rootRef.childByAppendingPath("messages")
        
        observeEventType()
        observeMessages()
        observeTyping()
        
    }
    
    //創建 數據
    @IBAction func buttonPressed(sender: UIButton) {
        //通過 childByAutoId()，我們獲得一個子對象引用，該對象有一個自動創建的唯一 key。
        let itemRef = messageRef.childByAutoId() // 1
        
        let messageItem = [ // 2 用一個字典來保存消息
            "text": "hello",
            "senderId": senderId
        ]
        
        itemRef.setValue(messageItem) // 3 將字典保存到新的子引用中。

    }
    
    //與 Firebase 保持實時同步
    func observeEventType() {
        //通過 Firebase App URL，我們創建了一個 Firebase 數據庫引用。
        //我們指定的這個 URL 指向了我們想讀取的數據。
        let ref = Firebase(url: BASE_URL + "/messages") // 1
        //用 FEventType.ChildAdded 參數調用 observeEventType(_:FEventType:) 方法。
        //在每當位於該 URL 的對象添加了新的子對象時都會觸發一次 child-added 事件。
        ref.observeEventType(.ChildAdded) { (snapshot: FDataSnapshot!) in
            print(snapshot.value)
        }
    }
    
    private func observeMessages() {
        // 1 創建一個查詢，限制要同步的數據為 25 條記錄。
        let messagesQuery = messageRef.queryLimitedToLast(25)
        // 2 監聽指定位置上的 .ChildAdded 事件，當結果集中有新的子對象添加和即將添加時觸發此事件。
        messagesQuery.observeEventType(.ChildAdded) { (snapshot: FDataSnapshot!) in
            // 3 從 snapshot.value 上讀取 senderId 和 text。
            let id = snapshot.value["senderId"] as! String
            let text = snapshot.value["text"] as! String
            print(id, text)
        }
    }
    
    //這個方法創建了一個引用，指向 URL 「/typingIndicator」，這個地址用於更新用戶的輸入狀態。
    //當用戶退出後，我們不需要這個數據了，因此我們可以用 onDiscounnectRemoveValue() 指定，當用戶離開則刪除該數據。
    private func observeTyping() {
        let typingIndicatorRef = rootRef.childByAppendingPath("typingIndicator")
        userIsTypingRef = typingIndicatorRef.childByAppendingPath(senderId)
        userIsTypingRef.onDisconnectRemoveValue()
        
        // 1 初始化一個查詢，用於查詢當前正在輸入的用戶。
        //這一句相當於「喂，Firebase，去 /typingIndicator 下面看看，告訴我哪些鍵值對的值是 true。」
        usersTypingQuery = typingIndicatorRef.queryOrderedByValue().queryEqualToValue(true)
        
        // 2 用 .Value 監聽改變，一旦這些值發生任何變化，就會立即通知你。
        usersTypingQuery.observeEventType(.Value) { (data: FDataSnapshot!) in
            
            // 3 You're the only typing, don't show the indicator
            //檢查結果中有多少用戶正在輸入。如果只有一個，則再檢查這個用戶是不是本地用戶，如果是，不顯示提示。
            if data.childrenCount == 1 && self.isTyping {
                return
            }
            
            //如果有不止一個用戶，而且本地用戶並沒有在輸入，則需要顯示輸入提示。
        }
    }
}
