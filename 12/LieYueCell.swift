//
//  LieYueCell.swift
//  12
//
//  Created by 王吉吉 on 2016/12/28.
//  Copyright © 2016年 王喆. All rights reserved.
//

import UIKit

class LieYueCell: UITableViewCell,UITableViewDelegate,UITableViewDataSource {
    //弹出回调
    typealias tanchuClearse = (_ height:CGFloat,_ tyCell:UITableViewCell) ->Void
    var tanchuClouseres:tanchuClearse?
    var height = CGFloat()
    var isTan = true
    var titleLabel = UILabel()
    var dateLabel = UILabel()
    var listenCountLabel = UILabel()
    var imageV = UIImageView()
    var playButton = UIButton()
    var bottomView = UIView()
    var listArr = NSArray()
    var listenArr = NSArray()
    var descriptionLabel = UILabel()
    var firModel = firstModel()
    var scrollView = UIScrollView()
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
       super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.creatUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        if size.height == 0{
        return CGSize.init(width: screenBounds.width, height: 250)
        }else{
        return size
        }
       
    }
    func creatUI(){
      self.titleLabel.frame = CGRect.init(x: 10, y: 20, width: screenBounds.width * 0.8, height: 20)
      self.titleLabel.font = UIFont.systemFont(ofSize: 16)
      self.titleLabel.textColor = UIColor.black
      self.addSubview(self.titleLabel)
        
      self.dateLabel.frame = CGRect.init(x: 10, y: self.titleLabel.frame.maxY+5, width: 50, height: 20)
        self.dateLabel.font = UIFont.systemFont(ofSize: 13)
        self.dateLabel.textColor = UIColor.lightGray
        self.addSubview(self.dateLabel)
      self.listenCountLabel.frame = CGRect.init(x: 70, y: self.titleLabel.frame.maxY+5, width: 150, height: 20)
        self.listenCountLabel.textColor = UIColor.gray
        self.addSubview(self.listenCountLabel)
      
        self.imageV.frame = CGRect.init(x: 0, y: self.dateLabel.frame.maxY + 5, width: screenBounds.width, height: 180)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(LieYueCell.tanchuClick))
        imageV.isUserInteractionEnabled = true
        self.imageV.addGestureRecognizer(tap)
        self.addSubview(self.imageV)
        
        self.playButton.frame = CGRect.init(x: screenBounds.width - 70, y: self.dateLabel.frame.maxY, width: 50, height: 50)
        self.playButton.addTarget(self, action: #selector(LieYueCell.playClick), for: UIControlEvents.touchUpInside)
        self.addSubview(self.playButton)
        print(imageV.frame)
        //创建列表
        self.bottomView.frame = CGRect.init(x: 0, y: self.imageV.frame.maxY, width: screenBounds.width, height: 400)
        self.bottomView.backgroundColor = UIColor.red
        descriptionLabel.frame = CGRect.init(x: 10, y: self.imageV.frame.maxY + 10, width: 200, height: 200)
        descriptionLabel.font = UIFont.systemFont(ofSize: 10)
        descriptionLabel.numberOfLines = 0
        self.bottomView.addSubview(descriptionLabel)
        
        let tabView = UITableView()
        tabView.frame = CGRect.init(x: 0, y: 400, width: screenBounds.width, height: 300)
        tabView.delegate = self
        tabView.dataSource = self
        tabView.rowHeight = 40
        tabView.register(UINib.init(nibName: "ListCell", bundle: nil), forCellReuseIdentifier: "list")
        self.bottomView.addSubview(tabView)
        
        let label = UILabel()
        label.text = "最近收听"
        label.frame = CGRect.init(x: 10, y: tabView.frame.maxY + 10, width: 150, height: 18)
        label.textColor = UIColor.black
        self.bottomView.addSubview(label)
        
        scrollView.frame = CGRect.init(x: 0, y: label.frame.maxY + 5, width: screenBounds.width, height: 30)
        self.bottomView.addSubview(scrollView)
          self.addSubview(self.bottomView)
          self.bottomView.isHidden = true
    }
    
    func playClick(){
    
    }
    func tanchuClick(){
        if isTan == true{
         isTan = false
            self.bottomView.isHidden = false
            let size = CGSize.init(width: screenBounds.width, height: self.height)
            _ = self.sizeThatFits(size)
            if tanchuClouseres != nil{
               tanchuClouseres!(900,self)
            }
        }else{
          isTan = true
            self.bottomView.isHidden = true
            let size = CGSize.init(width: screenBounds.width, height: 225)
            _ = self.sizeThatFits(size)
            if tanchuClouseres != nil{
                tanchuClouseres!(250,self)
            }
           
        }
        
    }
    func showDataWithModel(model:firstModel,tabArr:NSArray,listenArr:NSArray,indexPath:NSIndexPath){
        self.firModel = model
        self.titleLabel.text = model.mname
        self.dateLabel.text = String(format:"第%@期",model.mname)
        self.listenCountLabel.text = String(format:"🎧%@人听过",model.play_count)
        self.imageV.sd_setImage(with: NSURL.init(string:model.mphoto) as URL!)
        self.descriptionLabel.text = model.mdesc
        let height = self.getLabHeight(labelStr: self.firModel.mdesc, font: UIFont.systemFont(ofSize: 16), width: 200)
        self.height = height
        self.descriptionLabel.frame = CGRect.init(x: 10, y: -150, width: 200, height: height)
        scrollView.contentSize = CGSize.init(width: self.listenArr.count * 20, height: 20)
        for i in 0..<self.listenArr.count{
            let imgV = UIImageView()
            imgV.frame = CGRect.init(x:i * (30 + 10), y: 0, width: 30, height: 30)
            let model = self.listenArr[i] as! zhiboModel
            imgV.sd_setImage(with: NSURL.init(string:model.pimg) as URL!)
            imgV.layer.cornerRadius = 15
            imgV.layer.masksToBounds = true
            scrollView.addSubview(imgV)
        }
//mdesc	String
        self.listArr = tabArr
        self.listenArr = listenArr
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "list", for: indexPath) as! ListCell
        let model = self.listArr[indexPath.row] as! zhiboModel
        cell.showDataWithModel(model: model, indexPath: indexPath as NSIndexPath)
        return cell
    }
    
    
    
    
    
    
    //动态计算label高度
    func getLabHeight(labelStr:String,font:UIFont,width:CGFloat)->CGFloat{
        let statusLabelText: NSString = labelStr as NSString
        
        let size = CGSize.init(width: width, height: 900)
        
        let dic = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
        
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [String : AnyObject], context: nil).size
        
        return strSize.height
    }
}
