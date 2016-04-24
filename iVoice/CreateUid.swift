//
//  CreateUid.swift
//  iVoice
//
//  Created by jianhao on 2016/4/24.
//  Copyright © 2016年 cocoaSwifty. All rights reserved.
//

import Foundation
import Firebase

class CreateUid {
    
    func createUid(completion: (NSError?, FAuthData) -> ()) {
        let baseRef = Firebase(url: "\(BASE_URL)")
        baseRef.authAnonymouslyWithCompletionBlock { (error, data) in

            completion(error, data)
            
        }
    }
}