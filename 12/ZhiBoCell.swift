//
//  ZhiBoCell.swift
//  12
//
//  Created by 王吉吉 on 2016/12/21.
//  Copyright © 2016年 王喆. All rights reserved.
//

import UIKit

class ZhiBoCell: UITableViewCell {


    @IBOutlet var BigImageView: UIImageView!
    @IBOutlet var zhiBoButton: UIButton!
    @IBOutlet var usetCount: UILabel!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var nickLabel: UILabel!
    @IBOutlet var imageV: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func showDataWithModel(firstModel:firstModel,zhiboModel:zhiboModel, indexPath: IndexPath){
        let color = UIColor.black
        self.zhiBoButton.backgroundColor = color.withAlphaComponent(0.2)
        self.zhiBoButton.layer.cornerRadius = 10
        self.zhiBoButton.layer.borderWidth = 1
        self.zhiBoButton.layer.borderColor = UIColor.white.cgColor
        self.imageV.layer.cornerRadius = 25
        self.imageV.layer.masksToBounds = true
        
        if firstModel.portrait.contains("http"){
        }else{
            firstModel.portrait = String(format:"http://img2.inke.cn/%@",firstModel.portrait)
        }
        self.BigImageView.sd_setImage(with: NSURL.init(string: firstModel.portrait) as URL!)
        self.imageV.sd_setImage(with: NSURL.init(string: firstModel.portrait) as URL!)
        self.nickLabel.text = firstModel.nick
        if zhiboModel.city == ""{
         self.cityLabel.text = "难道在火星? >"
        }else{
         self.cityLabel.text = zhiboModel.city
        }
        self.usetCount.text = String(format:"%@",zhiboModel.online_users)
        
        
        
    }
    
}
