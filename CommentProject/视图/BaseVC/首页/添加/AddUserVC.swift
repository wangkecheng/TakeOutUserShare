//
//  AddUserVC.swift
//  CommentProject
//
//  Created by 王帅 on 2018/7/3.
//  Copyright © 2018 王帅. All rights reserved.
//

import UIKit
import HandyJSON
class AddUserVC: HQBaseVC,UITextFieldDelegate {

    @IBOutlet weak var userNameField: UITextField!
    var addFinishBlock:((_ model:UserModel) ->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func addUserAction(_ sender: Any) {
        let model:HQModel = HQModel()
        model.userName = self.userNameField.text;
        if model.userName?.count == 0{ 
            return
        }
        HQBaseServer.postObjc(objc: model, path: "addUser.php", isShowHud: false, isShowSuccessHud: false, attachObjc: AnyObject.self as AnyObject, successBlock: {[unowned self] (result:NSDictionary,attachObj:AnyObject) -> (Void) in
            let arr:NSArray = result["data"] as! NSArray
            let model =  JSONDeserializer<UserModel>.deserializeFrom(dict: (arr.firstObject as! NSDictionary))
            if model != nil && (self.addFinishBlock != nil){
                self.addFinishBlock!(model!) 
                self.view.makeToast(message: String.init(format: "添加 %@ 成功", (model?.userName)!) as NSString)
            }
        }) { (error:NSError) -> (Void) in
            
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n"{
            self.addUserAction(AnyObject.self)
            return false
        }
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning() 
    }

}
