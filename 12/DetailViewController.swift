//
//  DetailViewController.swift
//  12
//
//  Created by 王吉吉 on 2016/11/14.
//  Copyright © 2016年 王喆. All rights reserved.
//

import UIKit
import Alamofire
class DetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    //播放器对象
    let tabbar = TabBarViewController.TabBar
    var nickName = ""
    var trackIndex = ""
    var albuId = NSNumber()
    var coverLargeImage  = UIImageView()
    var coverSmallImage = UIImageView()
    var nicknameLabel = UILabel()
    var tracksLabel = UILabel()
    var lowImageView = UIImageView()
    var playButton = UIButton()
    var tableView = UITableView()
    var dataArr = NSMutableArray()
    var DYButton = UIButton()
    var model2 = firstModel()
    //保存当前的headImage
    var headImage:UIImage?
    var isFirst = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationClear()
        self.creatUI()
        self.initNet()

    }
    
    func creatUI() {
        self.coverLargeImage.frame = CGRect.init(x: 0, y: 0, width: screenBounds.width, height: 300)
        self.coverLargeImage.isUserInteractionEnabled = true
        self.coverSmallImage.frame = CGRect.init(x: 18, y: self.coverLargeImage.frame.maxY - 90, width: 70, height: 70)
        let blackViewImage  = UIImageView()
        blackViewImage.frame = CGRect.init(x: 0, y: 0, width: screenBounds.width, height: 300)
        blackViewImage.alpha = 0.2
        blackViewImage.backgroundColor = UIColor.black
        
        self.lowImageView.frame = CGRect.init(x: 8, y: self.coverLargeImage.frame.maxY - 100, width: 90, height: 90)
        self.lowImageView.image = UIImage(named:"album_cover_bg")
        self.playButton.frame = CGRect.init(x: 35, y: self.coverLargeImage.frame.maxY - 60, width: 25, height: 25)
        self.playButton.setImage(UIImage(named:"albumInfoCell_play"), for: UIControlState.normal)
        self.playButton.addTarget(self, action: Selector(("playButtonClick")), for: UIControlEvents.touchUpInside)
        self.nicknameLabel.frame = CGRect.init(x: 110, y: self.coverLargeImage.frame.maxY - 90, width: 200, height: 17)
        self.nicknameLabel.font = UIFont.systemFont(ofSize: 17)
       
        self.nicknameLabel.textColor = UIColor(red: 0.97, green:0.34, blue:0.58, alpha: 1)
        self.tracksLabel.frame = CGRect.init(x: 110, y: self.coverLargeImage.frame.maxY - 60, width: 100, height: 14)
        self.tracksLabel.font = UIFont.systemFont(ofSize: 13)
        self.tracksLabel.textColor = UIColor(red: 0.97, green:0.34, blue:0.58, alpha: 1)
        
        self.DYButton.setImage(UIImage(named:"dyCell_fav_n_meitu_1"), for: UIControlState.normal)
        self.DYButton.setImage(UIImage(named:"dyCell_fav_h"), for: UIControlState.disabled)
        self.DYButton.frame = CGRect.init(x: 110, y: self.coverLargeImage.frame.maxY - 30, width: 100, height: 17)
        self.DYButton.addTarget(self, action: #selector(DetailViewController.dyClick), for: UIControlEvents.touchUpInside)
        
        self.coverLargeImage.addSubview(blackViewImage)
        self.coverLargeImage.addSubview(self.DYButton)
        self.coverLargeImage.addSubview(self.tracksLabel)
        self.coverLargeImage.addSubview(self.nicknameLabel)
        self.coverLargeImage.addSubview(self.lowImageView)
        self.coverLargeImage.addSubview(self.coverSmallImage)
        self.coverLargeImage.addSubview(self.playButton)
        
        
        self.tableView = UITableView.init(frame: CGRect.init(x: 0, y: -150, width: screenBounds.width, height: screenBounds.height + 150), style: UITableViewStyle.plain)
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.tableHeaderView = self.coverLargeImage
        self.tableView.rowHeight = 65
        self.tableView .register(UINib.init(nibName: "DetailCell", bundle: nil), forCellReuseIdentifier: "Detail")
        self.view.addSubview(self.tableView)
        //判断是否订阅
        let isExist = DBManager.shareInstance.isExistAppForAppId(albumId: "\(self.albuId)",type:Favorite)
        if isExist{
          self.DYButton.isEnabled = false
        }else{
          self.DYButton.isEnabled = true
        }
        
        
    }
    func dyClick(){
        self.model2.trackIndex = self.trackIndex
        self.DYButton.isEnabled = false
        DBManager.shareInstance.insertAlbumModel(model: self.model2,type:Favorite)
    }
    //闭包回调
    func showNavigation(){
        self.navigationController?.navigationBar.isHidden = false
    }
    func initNet(){
        let u = "http://app.9nali.com/%@/albums/%@?page_id=1&isAsc=true&device=iPhone&version=1.1.5"
        let ulrS2 = String(format:u,self.trackIndex,self.albuId)
        Alamofire.request(ulrS2, method: .get).responseJSON {
            response in
            print(response)
            switch response.result{
            case.success:
            var dict = NSDictionary.init()
            dict = response.result.value as! NSDictionary
            if (dict.object(forKey: "ret") != nil){
                let retNum = dict["ret"] as Any
                if (retNum as AnyObject).intValue == 500{
                    self.creatAlertView()
                    return
                }
            }
            
            let Fdict = dict.object(forKey: "tracks") as! NSDictionary
            var arr = NSArray()
            arr = Fdict.value(forKey: "list") as! NSArray
            let Sdict = dict.object(forKey: "album") as! NSDictionary
            for dict2 in arr{
            let model1 = firstModel()
              self.model2 = firstModel()
                let dict4 = dict2 as! NSDictionary
                model1.setValuesForKeys(dict4 as! [String : Any])
                self.model2.setValuesForKeys(Sdict as! [String : Any])
                
                self.nickName = self.model2.nickname
                self.navigationItem.title = self.model2.title
                self.coverLargeImage.sd_setImage(with: NSURL.init(string: self.model2.coverLarge ) as URL?, completed: {(image: UIImage?, error: Error?, cacheType: SDImageCacheType, imageURL: URL?) in
                    if (image != nil){
                        self.headImage = UIImage()
                        self.headImage = image!
                    }
                })
                self.nicknameLabel.text = self.model2.nickname
                self.tracksLabel.text = "\(self.model2.tracks)"
                self.tracksLabel.text = String.init(format: "节目数%@", self.model2.tracks)
                self.coverSmallImage.sd_setImage(with:NSURL.init(string: self.model2.coverSmall) as URL?, placeholderImage: UIImage(named:"medium_head_male_default"))
                
                self.dataArr.add(model1)
            }
            self.tableView .reloadData()
            case.failure(let error):
                print(error)
                
            }
    }
    }
    func creatAlertView(){
        let alert = UIAlertController.init(title: "警告", message: "服务器开小差了", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction.init(title: "重试", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
            self.initNet()
        }))
        alert.addAction(UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel, handler: { (UIAlertAction) in
            print("取消")
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       // print("偏移量\(scrollView.contentOffset.y)")
        let y = scrollView.contentOffset.y
       
            var alp = CGFloat()
        if y < 0{
           alp = (60 - abs(y)) / 100
        }else{
            alp = (y + 60) / 100
        }
             //  print("透明度:\(alp)")
            let col = UIColor.init(red: 0.19, green: 0.76, blue: 0.49, alpha: alp)
        self.navigationController?.navigationBar.barTintColor = col
    }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "Detail", for: indexPath) as! DetailCell
       let model = self.dataArr[indexPath.row]
     
       cell .showDataWithModel(model: model as! firstModel, indexPath: indexPath as NSIndexPath)
        let musi = MusicViewController.music
        //cell回调
        cell.myDownClourse = {(downModel) in
            downModel.nickname = self.nickName
            if DBManager.shareInstance.isExistDownLoadForTrackId(trackId: String(format:"%@",downModel.trackId)) == false{
                WZAlertView.showWithText(text: "正在下载歌曲")
                DBManager.shareInstance.insertDownLoad(model: downModel)
                let down = DownViewController.downVC
                down.dataArr.add(downModel)
                down.tableView.reloadData()
            }else{
              WZAlertView.showWithText(text: "该电台已下载过")
            }
        }
        //播放器回调
        musi.downClouser = {(model) in
            model.nickname = self.nickName
            if DBManager.shareInstance.isExistDownLoadForTrackId(trackId: String(format:"%@",model.trackId)) == false{
                WZAlertView.showWithText(text: "正在下载歌曲")
                DBManager.shareInstance.insertDownLoad(model: model)
                let down = DownViewController.downVC
                down.dataArr.add(model)
                down.tableView.reloadData()
                
            }else{
                WZAlertView.showWithText(text:"该电台已下载过")
            }
    }
       return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let music = MusicViewController.music
        let model = self.dataArr[indexPath.row] as! firstModel
        music.resiveArr(arr: self.dataArr, index: indexPath.row,detail:self)
        music.infoModel = model
        music.nickName = self.nickName
        music.isLoad = false
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        //这个方法只执行一次
        _ = DetailViewController.myGlobal
        music.changeMusicInfo(str:"net")
        model.nickname = self.nickName
        DBManager.shareInstance.insertBrowese(model: model)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 10, options: UIViewAnimationOptions.allowUserInteraction, animations: {() in
            music.view.alpha = 1
            music.playView.alpha = 1
            music.titleView.alpha = 1
            music.titleView.frame = CGRect.init(x: 0, y: 30, width: screenBounds.width, height: 150)
            music.playView.frame = CGRect.init(x: 0, y: screenBounds.height - 150, width: screenBounds.width, height: 150)
            music.roundImageView.frame = CGRect(x:screenBounds.width/2 - 170,y:screenBounds.height/2 - 200,width:340,height:340)
            music.roundImageView2.frame = CGRect(x:screenBounds.width/2 - 170,y:screenBounds.height/2 - 200,width:340,height:340)
           
        }, completion: {(finshed:Bool) in
            music.playBackimage.alpha = 1
           
            
        })
    }
    /*
     
     */
    
    static let myGlobal:() = {
        let music = MusicViewController.music
      UIApplication.shared.keyWindow?.addSubview(music.view)
    }()
   
    func navigationClear(){
      
//        // 2、设置导航栏标题属性：设置标题颜色
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        // 3、设置导航栏前景色：设置item指示色
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        // 4、设置导航栏半透明
        self.navigationController?.navigationBar.isTranslucent = true
        
        // 5、设置导航栏背景图片
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        
        // 6、设置导航栏阴影图片
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
      //  self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor.init(red: 0.19, green: 0.76, blue: 0.49, alpha: 0))
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 0.19, green: 0.76, blue: 0.49, alpha: 0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
   
        // 2、设置导航栏标题属性：设置标题颜色
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        // 3、设置导航栏前景色：设置item指示色
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        // 4、设置导航栏半透明
        self.navigationController?.navigationBar.isTranslucent = false
        
        // 5、设置导航栏背景图片
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        
        // 6、设置导航栏阴影图片
        self.navigationController?.navigationBar.shadowImage = nil
      
        
       self.navigationController?.navigationBar.barTintColor = UIColor.init(patternImage: UIImage(named:"link_info")!)
        super.viewWillDisappear(true)
        UIApplication.shared.endReceivingRemoteControlEvents()
        self.resignFirstResponder()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        UIApplication.shared.beginReceivingRemoteControlEvents()
        self.becomeFirstResponder()
    }
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    
    override func remoteControlReceived(with event: UIEvent?) {
        let music = MusicViewController.music
        
        switch event!.subtype {
        case .remoteControlPlay:
            AFSoundManager.shared().resume()
            break
        case .remoteControlPause:
            AFSoundManager.shared().pause()
            break
        case .remoteControlNextTrack:
            music.nextClick()
            break
        case .remoteControlPreviousTrack:
            music.upClick()
            break
        default:
            break
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
   
}

