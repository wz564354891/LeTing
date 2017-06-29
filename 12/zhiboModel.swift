//
//  zhiboModel.swift
//  12
//
//  Created by 王吉吉 on 2016/12/20.
//  Copyright © 2016年 王喆. All rights reserved.
//

import UIKit

class zhiboModel: NSObject {
    //推流model
    
    var name = ""
    var share_addr = ""
    var stream_addr = ""
    var id = ""
    var image = ""
    var title = ""
    var city = ""
    var online_users = NSNumber()
    
    //猎乐Model
    var songname = ""
    var songer = ""
    var filename = ""
    var songphoto = ""
    
    //收听用户Model
    var pimg = ""
    
    
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
