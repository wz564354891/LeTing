//
//  CommitCell.swift
//  12
//
//  Created by 王吉吉 on 2016/11/29.
//  Copyright © 2016年 王喆. All rights reserved.
//

import UIKit

class CommitCell: UITableViewCell {

    @IBOutlet weak var regtimeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func showDataWithModel(model:firstModel,indexPath:NSIndexPath){
        self.logoImageView.layer.cornerRadius = self.logoImageView.frame.size.width/2
        self.logoImageView.layer.masksToBounds = true
        
        self.logoImageView.sd_setImage(with: NSURL.init(string: model.face) as URL!)
        
        self.contentLabel.text = model.content
        let regitme = model.regtime as NSString
        let t:Double = regitme.doubleValue
        let date = NSDate.init(timeIntervalSince1970: t)
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
         self.regtimeLabel.text =  String(format: "%@",df.string(from: date as Date))
        self.nickNameLabel.text = model.nickname
       
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
