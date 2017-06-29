//
//  FMHeadView.swift
//  12
//
//  Created by 王吉吉 on 2016/11/22.
//  Copyright © 2016年 王喆. All rights reserved.
//

import UIKit

class FMHeadView: UICollectionReusableView {
    var label = UILabel()
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes){
       
            label .removeFromSuperview()
            label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: screenBounds.width - 110, height:20))
            label.font = UIFont.systemFont(ofSize: 15)
            label.textAlignment = NSTextAlignment.center
            self.addSubview(label)
        
        let imaView = UIImageView()
        imaView.image = UIImage(named:"profileline")
        imaView.frame = CGRect.init(x: 0, y: 10, width: (screenBounds.width - 110) / 2 - 80, height: 1)
        self.addSubview(imaView)
        
        let imaView1 = UIImageView()
        imaView1.image = UIImage(named:"profileline")
        imaView1.frame = CGRect.init(x: (screenBounds.width - 110) / 2 + 70, y: 10, width: screenBounds.width / 2 - 80, height: 1)
        self.addSubview(imaView1)
        
        
      
        
     
    
    }
}
