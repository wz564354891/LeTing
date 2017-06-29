//
//  MVCell.swift
//  12
//
//  Created by 王吉吉 on 2016/11/25.
//  Copyright © 2016年 王喆. All rights reserved.
//

import UIKit

class MVCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bgImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func showDataWithModel(model:firstModel,indexPath:NSIndexPath){
       self.bgImageView.sd_setImage(with: NSURL.init(string: model.image) as URL?)
        self.titleLabel.text = model.title
        
    }
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
