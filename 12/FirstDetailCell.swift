//
//  FirstDetailCell.swift
//  12
//
//  Created by 王吉吉 on 2016/11/10.
//  Copyright © 2016年 王喆. All rights reserved.
//

import UIKit

class FirstDetailCell: UITableViewCell {

    @IBOutlet weak var CoverSmall: UIImageView!
    
    @IBOutlet weak var TracksLabel: UILabel!
    @IBOutlet weak var TitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func showDataWithModel(model:firstModel,indexPath:NSIndexPath,type:String){
        if type == "订阅"{
        self.contentView.backgroundColor = UIColor.white
        }else{
         
        }
        self.TitleLabel.text = model.title
        
          let url = model.coverSmall.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        self.CoverSmall.sd_setImage(with: NSURL.init(string:url!) as URL?, placeholderImage: UIImage(named:"medium_head_male_default"))
        self.TracksLabel.text = "节目数:\(model.tracks)"
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
