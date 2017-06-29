//
//  MyCanvas.swift
//  12
//
//  Created by 王吉吉 on 2016/11/16.
//  Copyright © 2016年 王喆. All rights reserved.
//

import UIKit

class MyCanvas: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        //把背景色设为透明
      self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
    override func draw(_ rect: CGRect) {
        let pathRect = self.bounds.insetBy(dx: 1, dy: 1)
        let path = UIBezierPath(roundedRect: pathRect, cornerRadius: frame.size.width)
        path.lineWidth = 3
        UIColor.green.setFill()
        UIColor.blue.setStroke()
        path.fill()
        path.stroke()
    }

}
