//
//  EditUserVC.swift
//  CommentProject
//
//  Created by 王帅 on 2018/7/3.
//  Copyright © 2018 王帅. All rights reserved.
//

import UIKit

class EditUserVC: HQBaseVC,UITextFieldDelegate {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var shareSwitch: UISwitch!
    var editFinishBlock:((_ model:UserModel)->())?
    var deleteBlock:((_ model:UserModel)->())?
    var shareStatusBlock:((_ model:UserModel)->())?
    var userModel:UserModel? = nil
    var model:UserModel{
        set{
            self.userModel = newValue
        }
        get{
            return self.userModel!
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameField.text = self.model.userName
        
        self.shareSwitch.isOn = false
        if  model.hasSpeech == "1" {
             self.shareSwitch.isOn = true
        }
    }
    
    @IBAction func deleteUserAction(_ sender: Any) {
        let model:HQModel = HQModel()
        model.userName = self.model.userName
        model.userID = self.model.userID
        HQBaseServer.postObjc(objc: model, path: "deleteUser.php", isShowHud: false, isShowSuccessHud: false, attachObjc:self.model, successBlock: {[unowned self] (result:NSDictionary,attachObj:AnyObject) -> (Void) in
            if self.deleteBlock != nil{
              self.deleteBlock!(attachObj as! UserModel)
              self.navigationController?.popViewController(animated: true)
            }
        }) { (error:NSError) -> (Void) in
            
        }
    }
    
    @IBAction func editUserNameAction(_ sender: Any) {
        let model:HQModel = HQModel()
        model.userName = self.nameField.text
        model.userID = self.model.userID
        self.model.userName = model.userName
        HQBaseServer.postObjc(objc: model, path: "editUser.php", isShowHud: false, isShowSuccessHud: false, attachObjc: self.model, successBlock: {[unowned self]  (result:NSDictionary,attachObj:AnyObject) -> (Void) in
            self.model.userName = result["userName"] as? String
            self.model.userID = (result["userID"]  as! String)
            if self.editFinishBlock != nil{
                self.view.makeToast(message: "修改成功")
                self.editFinishBlock!(self.model)
            }
        }) { (error:NSError) -> (Void) in
            
        }
    }
    
    @IBAction func setShareStatusAction(_ sender: Any) {
        let model:HQModel = HQModel()
            model.hasSpeech = "0"
        if self.shareSwitch.isOn {
            model.hasSpeech = "1"
        }
        model.userID = self.model.userID
        HQBaseServer.postObjc(objc: model, path: "setUserSpeechStatus.php", isShowHud: false, isShowSuccessHud: false, attachObjc:self.model, successBlock: {[unowned self] (result:NSDictionary,attachObj:AnyObject) -> (Void) in
            
               self.model.hasSpeech = (result["hasSpeech"] as! String)
            if  self.model.hasSpeech == "0"{
                 self.view.makeToast(message:"修改为未分享状态")
            }else{
                 self.view.makeToast(message:"修改为已分享状态")
            }
           
            if self.shareStatusBlock != nil {
               self.shareStatusBlock!(self.model)
            }
        }) { (error:NSError) -> (Void) in
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
