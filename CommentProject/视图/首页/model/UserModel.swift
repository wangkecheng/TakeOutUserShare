//
//  UserModel.swift
//  CommentProject
//
//  Created by 王帅 on 2018/7/3.
//  Copyright © 2018 王帅. All rights reserved.
//

import UIKit
import HandyJSON
class UserModel: HandyJSON {
    var userName: String? = nil
    var userID: String? = nil
    var hasSpeech: String? = nil
    var isToAddUser: Bool? = false
    var isNextShare: Bool? = false
    required init(){
        
    }
}
