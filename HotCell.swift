//
//  HotCell.swift
//  12
//
//  Created by 王吉吉 on 2016/11/21.
//  Copyright © 2016年 王喆. All rights reserved.
//

import UIKit

class HotCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playTimesLabel: UILabel!
    @IBOutlet weak var bgImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func showDataWithModel(model:firstModel,indexPath:NSIndexPath){
       self.titleLabel.text = model.title
        if model.plays_counts != nil{
            self.playTimesLabel.text = "\(model.plays_counts)"

        }
        self.bgImageView.sd_setImage(with: NSURL.init(string: model.coverLarge) as URL?)
    
    }

}
