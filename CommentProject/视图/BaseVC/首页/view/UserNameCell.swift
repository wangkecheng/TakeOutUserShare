
//
//  UserNameCell.swift
//  CommentProject
//
//  Created by 王帅 on 2018/7/3.
//  Copyright © 2018 王帅. All rights reserved.
//

import UIKit

class UserNameCell: UICollectionViewCell {
    
    @IBOutlet weak var nameBtn: UIButton!
    
    @IBOutlet weak var speechStatusLbl: UILabel!
    var newModel:UserModel!
    var addBlock:(()->())?
    var editBlock:((_ userModel:UserModel)->())?
    var model:UserModel{
        set{
        self.newModel = newValue
        self.nameBtn.setTitle(self.newModel.userName, for: UIControlState.normal)
             self.contentView.backgroundColor = UIColorFromHX(rgbValue:0xD8D8D8)
             self.speechStatusLbl.text = ""
            if self.newModel.hasSpeech == "1" {
                self.contentView.backgroundColor = UIColor.purple
                self.speechStatusLbl.text = "已分享"
            }
            if  self.newModel?.isNextShare == true{
                self.contentView.backgroundColor = UIColorFromHX(rgbValue: 0xFF7078)
                self.speechStatusLbl.text = "下周分享"
            }
        }
        get{
            return self.newModel
        }
    }
    
    @IBAction func nameBtnAction(_ sender: Any) {
        if newModel.isToAddUser!{
            if self.addBlock != nil {
                self.addBlock!()
            }
        }else{
            if self.editBlock != nil{
                self.editBlock!(newModel)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
