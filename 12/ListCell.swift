//
//  ListCell.swift
//  12
//
//  Created by 王吉吉 on 2016/12/29.
//  Copyright © 2016年 王喆. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet var titlelabel: UILabel!
    @IBOutlet var gongerLabel: UILabel!
    @IBOutlet var imageV: UIImageView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }
    func showDataWithModel(model:zhiboModel,indexPath:NSIndexPath){
     self.titlelabel.text = model.songname
     self.gongerLabel.text = model.songer
     self.imageV.sd_setImage(with: NSURL.init(string: model.songphoto) as URL!)
        
    }
}
