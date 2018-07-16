//
//  HQBaseServer.swift
//  CommentProject
//
//  Created by oldDevil on 2018/6/27.
//  Copyright © 2018年 王帅. All rights reserved.
//

import UIKit
import Alamofire
 var manager:SessionManager? = nil
class HQBaseServer: NSObject {
    static  func postObjc(objc: HQModel,path:String,isShowHud:Bool,isShowSuccessHud:Bool,attachObjc:AnyObject, successBlock:@escaping (_ result:NSDictionary,_ attachObjc:AnyObject)->(Void),faultBlock:@escaping (_ error:NSError) -> (Void)) {
        let url:String = POST_HOST + path
        let dict:[String:String]? = objc.toJSON() as? [String : String]
        
        let header:HTTPHeaders = [
            "Accept":"application/json"
        ]
//        NSSet *set = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"application/javascript",nil];
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        let policies: [String: ServerTrustPolicy] = [
            "api.domian.cn": .disableEvaluation
        ]
        manager = Alamofire.SessionManager(configuration: configuration,serverTrustPolicyManager: ServerTrustPolicyManager(policies: policies))
        manager?.startRequestsImmediately = true
        manager?.delegate.sessionDidReceiveChallenge = {
            session,challenge in
            return    (URLSession.AuthChallengeDisposition.useCredential,URLCredential(trust:challenge.protectionSpace.serverTrust!))
        }
        //JSONEncoding.default
        manager?.request(url, method: HTTPMethod.post, parameters: dict, encoding: URLEncoding.httpBody, headers: header).responseJSON(queue: DispatchQueue.main, options:  JSONSerialization.ReadingOptions.mutableContainers) { (response) in
//            if response.data != nil{
//                let str = NSString.init(data: response.data!, encoding: String.Encoding.utf8.rawValue)
//                print(str);
//            }
            if (response.result.value != nil) {
                let dict:NSDictionary  = response.result.value as! NSDictionary
                let code = Int(dict["code"] as! String)
                if code == 200{
                    successBlock(dict,attachObjc)
                }else{
                    faultBlock(NSError.init())
                }
            }else{
                faultBlock(NSError.init())
            }
        }
    }
}
