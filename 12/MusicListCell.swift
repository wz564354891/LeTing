//
//  MusicListCell.swift
//  12
//
//  Created by 王吉吉 on 2016/11/22.
//  Copyright © 2016年 王喆. All rights reserved.
//

import UIKit

class MusicListCell: UICollectionViewCell {

    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bgImageView: UIImageView!
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }
    func showDataWithModel(model:firstModel,indexPath:NSIndexPath){
        self.titleLab.text = model.personDescribe
        self.nameLabel.text = model.nickname
        self.bgImageView.sd_setImage(with: NSURL.init(string: model.mediumLogo) as URL?)
        
    }

}
