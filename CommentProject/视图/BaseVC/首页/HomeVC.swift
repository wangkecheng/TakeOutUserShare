//
//  HomeVC.swift
//  CommentProject
//
//  Created by 王帅 on 2018/7/3.
//  Copyright © 2018 王帅. All rights reserved.
//

import UIKit
import HandyJSON

class HomeVC: HQBaseVC,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    var arrModel:[UserModel] = []
    var notShareArr:[UserModel] = []
    var selectedIndex:Int = 0
    var nextShareUser:UserModel?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowlayout: UICollectionViewFlowLayout!
    @IBOutlet weak var nameLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib.init(nibName: "UserNameCell", bundle: nil), forCellWithReuseIdentifier: "UserNameCell")
        
        flowlayout.scrollDirection = UICollectionViewScrollDirection.vertical
        flowlayout.sectionInset =  UIEdgeInsetsMake(10, 10, 0, 10)
        flowlayout.minimumInteritemSpacing = 10//同一行
        flowlayout.minimumLineSpacing = 10//同一列
        getData()
    }
    func getData() {
        HQBaseServer.postObjc(objc:HQModel(), path: "getUsers.php", isShowHud: false, isShowSuccessHud: false, attachObjc:AnyObject.self as AnyObject, successBlock: { [unowned self] (result:NSDictionary,attachObj:AnyObject) -> (Void)  in
            
            let data = result["data"] as! NSArray
            for  dict in  data {
                let model = JSONDeserializer<UserModel>.deserializeFrom(dict: dict as? NSDictionary)
                if (model != nil){
                    self.arrModel.append(model!)
                }
            }
           
            for model:UserModel in self.arrModel {
                if  model.hasSpeech == "0"{
                    self.notShareArr.append(model)
                }
                if model.isNextShare! {
                    self.nextShareUser = model
                    self.navigationItem.title = NSString.init(format: "下周分享:%@", model.userName!) as String
                }
            }
            if self.notShareArr.count>0{
                self.nameLbl.text = self.notShareArr[0].userName
            } 
            let addModel:UserModel = UserModel()
            addModel.isToAddUser = true
            addModel.userName = "+"
            self.arrModel.append(addModel)
            DispatchQueue.main.async { [unowned self] in
                self.collectionView.reloadData()
            }
        }) {[unowned self] (error:NSError) -> (Void) in
            
        }
         
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    //返回多少个cell
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrModel.count
    }
    //返回自定义的cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:UserNameCell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserNameCell", for: indexPath) as! UserNameCell
        cell.addBlock = { [unowned self] ()->()in
            let VC:AddUserVC = AddUserVC()
            VC.title = "添加新人"
            VC.addFinishBlock = {[unowned self] (userModel:UserModel) ->()  in
                self.arrModel.insert(userModel, at: self.arrModel.count - 1)
                DispatchQueue.main.async {

                    self.collectionView.reloadData()
                }
            }
            self.navigationController?.pushViewController(VC, animated: true)
        }
        cell.editBlock = {[unowned self](userModel:UserModel)->() in
            let VC:EditUserVC = EditUserVC()
            VC.title = "编辑成员信息"
            VC.model = userModel
            VC.editFinishBlock = {(_ model:UserModel)->() in
                self.collectionView .reloadData()
            }
            VC.deleteBlock = {[unowned self](model:UserModel)->()in
                let userName = model.userName!
                var index = 0
                for userModel in self.arrModel{
                    if userModel.userID == model.userID{
                    self.arrModel.remove(at:index)
                        break
                    }
                     index = index + 1
                }
                DispatchQueue.main.async {[unowned self] in
                    self.collectionView.reloadData()
                    self.view.makeToast(message: String.init(format: "删除 %@ 成功", userName) as NSString )
                }
            }
            VC.shareStatusBlock = { [unowned self] (model:UserModel)->() in
                DispatchQueue.main.async { 
                    self.collectionView.reloadData()
                }
            }
            self.navigationController?.pushViewController(VC, animated: true)
        }
        cell.model = self.arrModel[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: (SCREEN_WIDTH - 4 * 10)/3.0, height: 50)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    @IBAction func startChooseAction(_ sender: Any) {
        
        printSelectName(count: 0, notShareArr: notShareArr)
    }
    func printSelectName(count:Int,notShareArr:[UserModel]) {
        if notShareArr.count == 0 {
            self.view .makeToast(message: "暂无可抽取的人")
            return
        }
        let index = Int(arc4random_uniform(UInt32(notShareArr.count)))
        let model:UserModel = notShareArr[index]
        self.nameLbl.text = model.userName
        if count != notShareArr.count * 2 {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.05) { [unowned self] in
                self.printSelectName(count: count + 1, notShareArr: notShareArr)
            }
        }else{
            self.selectedIndex = index
        }
    }
    
    @IBAction func confirmSelect(_ sender: Any) {
        if notShareArr.count == 0 {
            self.view .makeToast(message: "暂无可选中的人")
            return
        }

        let userModel:UserModel = notShareArr[self.selectedIndex]
        let model:HQModel = HQModel()
            model.hasSpeech = "1"
            model.isNextShare = "1"
            model.userID = userModel.userID
            self.navigationItem.title = NSString.init(format: "下周分享:%@", userModel.userName!) as String
        HQBaseServer.postObjc(objc: model, path: "setUserSpeechStatus.php", isShowHud: false, isShowSuccessHud: false, attachObjc: userModel, successBlock: {[unowned self] (result:NSDictionary,attachObj:AnyObject) -> (Void)  in
            
            let model:UserModel = userModel
            model.hasSpeech = result["hasSpeech"] as? String
            model.isNextShare = (result["isNextShare"] as! NSString).boolValue
            DispatchQueue.main.async { [unowned self] in
                self.nextShareUser?.isNextShare = false
                self.view.makeToast(message: String.init(format: "下周分享:%@",  self.navigationItem.title!) as NSString)
                 self.collectionView.reloadData()
            }
        }) { (error:NSError) -> (Void) in
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
