//
//  WZAlertView.swift
//  12
//
//  Created by 王吉吉 on 2016/12/14.
//  Copyright © 2016年 王喆. All rights reserved.
//

import UIKit

class WZAlertView: UIView {
    init(text:String){
      super.init(frame: CGRect.init(x: 0, y: 64, width: screenBounds.width, height: 64))
        self.frame = CGRect.init(x: 0, y: -64, width: screenBounds.width, height: 64)
        self.backgroundColor = oftenColor
        self.creatView(text:text)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    class func showWithText(text:String){
       let alert = WZAlertView.init(text: text)
        
          UIApplication.shared.keyWindow?.addSubview(alert)
        
           }
    func creatView(text:String){
        let label = UILabel()
        label.text = text
        label.textColor = UIColor.white
        label.frame = CGRect.init(x: 45, y: 35, width: 200, height: 20)
        label.font = UIFont.systemFont(ofSize: 16)
        self.addSubview(label)
        //player_btn_download_normal
        let imaegV  = UIImageView()
        imaegV.frame = CGRect.init(x: 10, y: 20, width: 40, height: 40)
        imaegV.image = UIImage(named:"actionIconDownload_h_b")
        self.addSubview(imaegV)
        
        UIView.animate(withDuration: 0.5, animations: {() in
        self.frame = CGRect.init(x: 0, y: 0, width: screenBounds.width, height: 64)
        }, completion: {(finished) in
            self.perform(#selector(WZAlertView.hideView), with: nil, afterDelay: 0.5)
        })
    }
    func hideView(){
        UIView.animate(withDuration: 0.5, animations: {() in
        self.frame = CGRect.init(x: 0, y: -64, width: screenBounds.width, height: 64)
        })
       
    }
}
