//
//  TableViewCell.swift
//  12
//
//  Created by 王吉吉 on 2016/11/3.
//  Copyright © 2016年 王喆. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    var _button:UIButton!
    var headImage = UIImageView()
    var nickNameLabel = UILabel()
    var personDescribeLabel = UILabel()
    var albumsLabel = UILabel()

    override init(style:UITableViewCellStyle,reuseIdentifier:String?){
     super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.creatUI()
        self.backgroundColor = UIColor.init(red: 0.85, green:1, blue:1, alpha: 1)
        
    }
    //?????????
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //创建UI
    func creatUI(){
       headImage.frame = CGRect.init(x: 5, y: 10, width: 40, height: 40)
       self.addSubview(headImage)
       
        nickNameLabel.textColor = UIColor.orange
        nickNameLabel.frame = CGRect.init(x:60, y: 5, width: 200, height: 15)
        nickNameLabel.font = UIFont.systemFont(ofSize: 13)
        self.addSubview(nickNameLabel)
        
        personDescribeLabel.textColor = UIColor.orange
        personDescribeLabel.frame = CGRect.init(x:60, y: 25, width: 200, height: 15)
        personDescribeLabel.font = UIFont.systemFont(ofSize: 13)
        self.addSubview(personDescribeLabel)
        
        albumsLabel.textColor = UIColor.orange
        albumsLabel.frame = CGRect.init(x:60, y: 40, width: 100, height: 15)
        albumsLabel.font = UIFont.systemFont(ofSize: 13)
        self.addSubview(albumsLabel)
        
        
        
    }
    
    //请求数据
    func showDataWithModel(model:firstModel,indexPath:NSIndexPath){
        headImage .sd_setImage(with: NSURL.init(string: model.mediumLogo) as URL?, placeholderImage:UIImage(named:"medium_head_male_default"))
        self.nickNameLabel.text = model.nickname
        self.personDescribeLabel.text = model.personDescribe
        self.albumsLabel.text = "专辑数:\(model.albums)"
        
        
    }
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
