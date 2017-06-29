//
//  MyViewController.swift
//  12
//
//  Created by 王吉吉 on 2016/12/5.
//  Copyright © 2016年 王喆. All rights reserved.


import UIKit
import SnapKit
import Alamofire
class MyViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    //push闭包
    typealias pushClouser = (_ vc:UIViewController) ->Void
    var myPushClouser:pushClouser?
    var loginView = UIView()
    var sixButtonView = UIView()
    var tableView = UITableView()
    var dataArr = NSMutableArray()
    var label = UILabel()
    var CommitLabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
     self.creatUI()
     self.readDB()
     
    }
    func readDB() {
        self.dataArr.removeAllObjects()
      let arr = DBManager.shareInstance.readAlbumModelsWithType(type: Favorite)
        for model in arr{
         self.dataArr.add(model)
           
        }
        if self.dataArr.count == 0{
        self.CommitLabel.isHidden = false
        }
        label.text = String(format:"我的电台 %d",self.dataArr.count)
        self.tableView.reloadData()
        
    }
    func creatUI(){
        
     loginView.frame = CGRect.init(x: 0, y: 0, width: screenBounds.width, height: 100)
     loginView.backgroundColor = UIColor.white
     self.view.addSubview(loginView)
        
      //标题
     let titleLabel = UILabel()
        titleLabel.text = "乐听FM,乐听你的生活"
        titleLabel.frame = CGRect.init(x: 0, y: 20, width: screenBounds.width, height: 20)
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = NSTextAlignment.center
        loginView.addSubview(titleLabel)
        
     //立即登录按钮
      let loginButton = UIButton.init(type: UIButtonType.custom)
        loginButton.frame = CGRect.init(x: screenBounds.width/2 - 60, y: (loginView.frame.maxY) - 45, width: 120, height: 40)
        loginButton.setTitle("立即登录", for: UIControlState.normal)
        loginButton.setTitleColor(oftenColor, for: UIControlState.normal)
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = oftenColor.cgColor
        loginView.addSubview(loginButton)
        
      //6个按钮
        sixButtonView.frame = CGRect.init(x: 0, y: (loginView.frame.maxY), width: screenBounds.width, height: 200)
        sixButtonView.backgroundColor = UIColor.white
        self.view.addSubview(sixButtonView)
        //横向间隔
        let wSpace = (screenBounds.width - 3 * 100) / 4
        let hSpace = (200 - 2 * 100) / 3
        let imageArr = ["mymusic_icon_allsongs_normal@2x","mymusic_icon_download_normal@2x","mymusic_icon_history_normal@2x","mymusic_icon_favorite_normal@2x","mymusic_icon_mv_normal@2x","mymusic_icon_recognizer_normal@2x"]
        let titleArr = ["我的订阅","下载电台","最近收听","我喜欢","下载MV","我的订阅"]
        for i in 0..<6{
            print(i)
            let button = UIButton()
            button.frame = CGRect.init(x: Int(wSpace + (CGFloat)(i%3) * (100+wSpace)), y:hSpace + (i/3)*(hSpace+100), width: 100, height: 100)
            button.setImage(UIImage(named:imageArr[i]), for: UIControlState.normal)
            button.titleEdgeInsets = UIEdgeInsetsMake((button.imageView?.frame.size.height)!, -((button.imageView?.frame.size.width)!), 0, 0)
            button.tag = 201+i
            button.setTitle(titleArr[i], for: UIControlState.normal)
            button.setTitleColor(UIColor.black, for: UIControlState.normal)
            button.addTarget(self, action: #selector(sixButtonClick(_:)), for: UIControlEvents.touchUpInside)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
            button.imageEdgeInsets = UIEdgeInsetsMake(-30, 23, 0, -(button.titleLabel?.bounds.size.width)!)
            sixButtonView.addSubview(button)
        }
        
        let sectionView = UIView.init(frame: CGRect.init(x: 0, y: 200, width: screenBounds.width, height: 50))
        sectionView.backgroundColor = UIColor.init(red:0.98,green:0.99 ,blue:0.97 ,alpha:1.00)
        self.view.addSubview(sectionView)
        
        label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: screenBounds.width, height: 50))
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.systemFont(ofSize: 17)
        sectionView.addSubview(label)
        
        let otherButton = UIButton.init(frame: CGRect.init(x: screenBounds.width - 50, y: -5, width: 50, height: 50))
        otherButton.setImage(UIImage(named:"singershow_arrow_right_h"), for: UIControlState.normal)
        otherButton.addTarget(self, action: #selector(CollectionHeadView.otherClick), for: UIControlEvents.touchUpInside)
        sectionView.addSubview(otherButton)
        
        
        tableView = UITableView.init(frame: CGRect.init(x: 0, y: sixButtonView.frame.maxY, width: screenBounds.width, height: screenBounds.height - loginView.frame.height - sixButtonView.frame.height), style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        tableView.tableHeaderView = sectionView
        tableView.tableFooterView = UIView()
        tableView.register(UINib.init(nibName: "FirstDetailCell", bundle: nil), forCellReuseIdentifier: "tab")
        self.view.addSubview(tableView)
        
        self.CommitLabel = UILabel.init(frame: CGRect.init(x: 0, y:screenBounds.height * 0.7, width: screenBounds.width, height: 20))
        self.CommitLabel.text = "暂无订阅"
        self.CommitLabel.font = UIFont.systemFont(ofSize: 18)
        self.CommitLabel.isHidden = true
        self.CommitLabel.textAlignment = NSTextAlignment.center
        self.view.addSubview(self.CommitLabel)
        
        
    }
    
    
    func sixButtonClick(_ btn:UIButton){
        switch  btn.tag{
        case 201:
            let dingyue = DIngYueController()
            if myPushClouser != nil{
             myPushClouser!(dingyue)
            }
        case 202:
           //下载
            let down = DownViewController.downVC
            if myPushClouser != nil{
                myPushClouser!(down)
            }
        case 203:
            //最近收听
            let Favorite = FavoriteViewController()
            if myPushClouser != nil{
                myPushClouser!(Favorite)
            }
        case 204:
            let love = LoveViewController()
            if myPushClouser != nil{
                myPushClouser!(love)
            }
        case 205:
            //下载MV
            let MVDown = MVDownViewController.mvDownVC
            if myPushClouser != nil{
                myPushClouser!(MVDown)
            }
        case 206:
            print("")
        default:
            break
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:FirstDetailCell = tableView.dequeueReusableCell(withIdentifier: "tab", for: indexPath) as!FirstDetailCell
        
        let model:firstModel = self.dataArr[indexPath.row] as! firstModel
        cell.showDataWithModel(model: model, indexPath: indexPath as NSIndexPath,type:"订阅")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model:firstModel = self.dataArr[indexPath.row] as! firstModel
        print(model.albumId)
        NotificationCenter.default.post(name: NSNotification.Name("pushNotification"), object: model)
    }
    
}
