
//
//  MusicViewController.swift
//  12
//
//  Created by 王吉吉 on 2016/11/3.
//  Copyright © 2016年 王喆. All rights reserved.
//

var playUrl = "http://fdfs.xmcdn.com/group8/M09/3A/95/wKgDYVWbcy-SZFygAFiZzgUFTtw307.mp3"
var consumeKey = "PVS6ZAxfGOxxH5BT7IZlQJfsnjQadhEuHmf29M76"
import UIKit
import Alamofire


class MusicViewController: UIViewController,UIScrollViewDelegate {
    //隐藏导航闭包
    typealias showNavigation = ()
    //下载回调
    typealias downClo = (_ model:firstModel) ->Void
    var downClouser:downClo?
   static let music  = MusicViewController()
    var detail1 = DetailViewController()
    var downVC = DownViewController()
    var favorite = FavoriteViewController()
    //对外属性
    var infoModel = firstModel()
    var trackId = NSNumber()
    var screenBounds:CGRect = UIScreen.main.bounds
    var roundImageView:UIImageView = UIImageView()
    var roundImageView2:UIImageView = UIImageView()
    var midRoundImageView:UIImageView = UIImageView()
    var coverSmall = ""
    var nickName = ""
    //成员变量
    var sqButton = UIButton()
    var dict = NSDictionary()
    var startButton :UIButton?
    var titleScrollView:UIScrollView = UIScrollView()
    var titleLabel:UILabel = UILabel()
    var titleLabel2:UILabel = UILabel()
    var titleLabelScrollView = UIScrollView()
    var timer:Timer = Timer()
    var timer2 = Timer()
    var isBack:Bool = Bool()
    var slider:UISlider = UISlider()
    var startTime = UILabel()
    var overTime = UILabel()
    var isPlay = Bool()
    var playButton = UIButton()
    var playBackimage = UIImageView()
    var backImage = UIImageView()
    var visualeffectview = UIVisualEffectView()
    var blureffect = UIBlurEffect()
    var titleView = UIView()  //顶部名字view
    var playView  = UIView() //下部播放按钮view
    var isLoad = false
    var dataArr = NSMutableArray()
    var _index = Int()
    var singerLabel = UILabel()
    var bgView = UIImageView()
   // var rectLayer = CALayer()
    var isList = true
    var isFavorite = false
    var isWidth = CGFloat()
    var musicDict = NSMutableDictionary()
    
    var tabbar = TabBarViewController.TabBar
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        UIApplication.shared.beginReceivingRemoteControlEvents()
        self.becomeFirstResponder()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        UIApplication.shared.endReceivingRemoteControlEvents()
        self.resignFirstResponder()
    }
    override var canBecomeFirstResponder: Bool{
      return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
            isLoad = true
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
            self.isPlay = true
           // self.initNet()
            self.creatUI()
            startAnimation()
            self.setAudio()//设置后台音频背景播放
        let model = self.dataArr[self._index] as! firstModel
         let btn = self.view.viewWithTag(103) as! UIButton
        if DBManager.shareInstance.isExistLoveForTrackId(trackId:String(format:"%@",model.trackId)){
            isFavorite = true
         btn.setImage(UIImage(named:"player_btn_favorited_normal"), for: UIControlState.normal)
        }else{
            isFavorite = false
          btn.setImage(UIImage(named:"player_btn_favorite_normal"), for: UIControlState.normal)
        }
        
       
    
    }
    //设置锁屏界面
    func setLockView(current:CGFloat,totalTime:CGFloat){
        let mp = MPNowPlayingInfoCenter.default()
        musicDict.setObject(infoModel.title, forKey: MPMediaItemPropertyTitle as NSCopying)
       // musicDict.setObject(infoModel.albums, forKey: MPMediaItemPropertyArtist as NSCopying)
        musicDict.setObject(1.0, forKey: MPMediaItemPropertyRating as NSCopying)
        musicDict.setObject(totalTime, forKey: MPMediaItemPropertyPlaybackDuration as NSCopying)
        musicDict.setObject(current, forKey: MPNowPlayingInfoPropertyElapsedPlaybackTime as NSCopying)
        mp.nowPlayingInfo = musicDict as? [String : Any]

        
    }
    func setAudio(){
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            UIApplication.shared.beginReceivingRemoteControlEvents()
        }catch{
            
        }
    }
    
    func initNet(){
         let ulr = "http://app.9nali.com/935/tracks/\(infoModel.albumId)?device=iPhone&version=1.1.5"
        Alamofire.request(ulr, method: .get).responseJSON {
            response in
            switch response.result{
            case.success:
            self.dict = response.result.value as! NSDictionary
              self.play(urlStr: self.infoModel.playUrl64 as NSString)
            case.failure(let error):
                print(error)
            }
        }
           
    }
    func displayLinkClick(){
        
        UIView.animate(withDuration: 20, animations: {() in
            
            self.titleLabelScrollView.contentOffset.x = self.isWidth
        }, completion: {(finshed) in
            self.titleLabelScrollView.contentOffset.x = 0
            self.perform(#selector(MusicViewController.displayLinkClick), with: self, afterDelay: 1)
            
        })
      
    }
    func downGesture(){
       self.popClick()
    }
    func creatUI() {
        isBack = true
    timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(MusicViewController.timerClick), userInfo: nil, repeats: true)
    //timer2 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(MusicViewController.displayLinkClick), userInfo: nil, repeats: true)
        self.perform(#selector(MusicViewController.displayLinkClick), with: self, afterDelay: 1)
        self.blureffect = UIBlurEffect.init(style: UIBlurEffectStyle.dark)
        self.visualeffectview = UIVisualEffectView.init(effect: self.blureffect)
        self.visualeffectview.frame = CGRect.init(x: 0, y: 0, width: screenBounds.width, height: screenBounds.height)
        self.visualeffectview.alpha = 0.575
        
        
        
       backImage.frame = CGRect(x:0,y:0,width:screenBounds.width,height:screenBounds.height)
       backImage.image = UIImage(named:"player_albumblur_default")
       backImage.alpha = 0.85
        
        bgView  = UIImageView(frame: CGRect(x:0,y:0,width:self.view.bounds.width,height:self.view.bounds.height))
        bgView .sd_setImage(with: NSURL.init(string: infoModel.coverLarge) as URL?, placeholderImage: nil)
        self.view.insertSubview(bgView, at: 0)
        self.view.insertSubview(backImage, at: 1)
        self.view.insertSubview(self.visualeffectview, at: 2)
        
        //增加下拉手势
        let topView = UIView.init(frame: self.view.frame)
        topView.backgroundColor = UIColor.clear
        self.view.insertSubview(topView, at: 999)
        
        let downRecognizer = UISwipeGestureRecognizer.init(target: self, action: #selector(MusicViewController.downGesture))
        downRecognizer.direction = UISwipeGestureRecognizerDirection.down
        topView.addGestureRecognizer(downRecognizer)
        
       
        roundImageView2.frame = CGRect(x:5,y:screenBounds.height-5,width:30,height:30)
        self.setRoundImage2()
        roundImageView2.alpha = 0
        
        roundImageView.frame = CGRect(x:5,y:screenBounds.height-5,width:30,height:30)
        self.setRoundImage()
       
        playBackimage.frame =  CGRect(x:screenBounds.width/2 - 195,y:screenBounds.height/2 - 245,width:390,height:390)
        playBackimage.image =  UIImage(named:"player_albumcover_default")
        playBackimage.alpha = 0
        self.view.addSubview(roundImageView2)
        self.view.addSubview(roundImageView)
       
        
        
         titleView.frame = CGRect.init(x: 0, y: -150, width: screenBounds.width, height: 150)
         titleView.backgroundColor = UIColor.clear
         self.view.addSubview(titleView)
        
         let backButton = UIButton.init(type: UIButtonType.custom)
         backButton.frame = CGRect.init(x: 0, y: -10, width: 50, height: 50)
         backButton.setImage(UIImage(named:"back"), for: UIControlState.normal)
         backButton.addTarget(self, action: #selector(MusicViewController.popClick), for: UIControlEvents.touchUpInside)
        
        //view.clipBounds=YES; 
        let width:CGFloat = getLabWidth(labelStr: infoModel.title, font: UIFont.systemFont(ofSize: 17), height: 20)
        isWidth = width
        
        titleLabelScrollView.frame = CGRect.init(x: 60, y: 0, width: screenBounds.width - 110, height: 30)
        titleLabelScrollView.contentSize = CGSize.init(width: width * 2, height: 30)
        
         titleView.addSubview(titleLabelScrollView)
         titleLabel = UILabel.init(frame: CGRect.init(x: 0, y: 5, width: width, height: 20))
         titleLabel.clipsToBounds = true
         titleLabel.textAlignment = NSTextAlignment.center
         titleLabel.text = infoModel.title
         titleLabel.font = UIFont.systemFont(ofSize: 17)
         titleLabel.textColor = UIColor.white
         titleLabelScrollView.addSubview(titleLabel)
        
        titleLabel2 = UILabel.init(frame: CGRect.init(x: width, y: 5, width: width, height: 20))
        titleLabel2.text = infoModel.title
        titleLabel2.font = UIFont.systemFont(ofSize: 17)
        titleLabel2.textColor = UIColor.white
        titleLabelScrollView.addSubview(titleLabel2)
        
        
        singerLabel =  UILabel.init(frame: CGRect.init(x: 20, y: 35, width: screenBounds.width - 40, height: 20))
         singerLabel.textAlignment = NSTextAlignment.center
        singerLabel.text = String(format:" ——  %@  —— ",self.nickName)
         singerLabel.font = UIFont.systemFont(ofSize: 15)
         singerLabel.textColor = UIColor.white
        
        sqButton = UIButton.init(type: UIButtonType.custom)
        sqButton.setImage(UIImage(named:"player_btn_hq_sel_normal"), for: UIControlState.normal)
        sqButton.tag = 2;
        sqButton.addTarget(self, action: #selector(sqClike(_:)), for: UIControlEvents.touchUpInside)
        
        sqButton.frame = CGRect.init(x: screenBounds.width/2 - 25, y: 65, width: 50, height: 20)
        
         let otherButton = UIButton.init(type: UIButtonType.custom)
         otherButton.frame = CGRect.init(x: screenBounds.width - 45, y: -10, width: 50, height: 50)
         otherButton.setImage(UIImage(named:"main_tab_more_h"), for: UIControlState.normal)
         otherButton.addTarget(self, action: Selector(("otherClick")), for: UIControlEvents.touchUpInside)
        
        titleView.addSubview(sqButton)
        titleView.addSubview(backButton)
       // titleView.addSubview(titleLabel)
        titleView.addSubview(singerLabel)
        titleView.addSubview(otherButton)
        
        //播放关键帧动画
        //self.startKeyAnimaiton()
        
        //创建播放器界面
        playView.frame = CGRect.init(x: 0, y: screenBounds.height + 150, width: screenBounds.width, height: 150)
        playView.backgroundColor = UIColor.clear
        self.view.addSubview(playView)
        
        startTime.frame = CGRect(x:5,y:0,width:50,height:20)
        startTime.font = UIFont.systemFont(ofSize: 13)
        startTime.textColor = UIColor.white
        startTime.text = "00:00"
        
        overTime.frame = CGRect(x:screenBounds.width - 48,y:0,width:50,height:20)
        overTime.font = UIFont.systemFont(ofSize: 13)
        overTime.textColor = UIColor.white
        overTime.text = "00:00"
       
        slider.frame = CGRect(x:50,y:10,width:screenBounds.width - 100,height:2)
        slider.addTarget(self, action: #selector(MusicViewController.backOrForwardAudio), for: UIControlEvents.touchUpInside)
        slider.setThumbImage(UIImage(named:"player_slider_playback_thumb"), for: UIControlState.normal)
        slider.minimumTrackTintColor = UIColor.init(red: 0.19, green: 0.76, blue: 0.49, alpha: 1)
        slider.value = 0
       
        playButton.frame = CGRect.init(x: screenBounds.width/2 - 25, y: 40, width: 50, height: 50)
        playButton.setImage(UIImage(named:"player_btn_play_normal"), for: UIControlState.normal)
        playButton.addTarget(self, action: #selector(MusicViewController.playClick), for: UIControlEvents.touchUpInside)
       
        let upButton = UIButton()
        upButton.frame = CGRect.init(x: 50, y: 45, width: 40, height: 40)
        upButton.setImage(UIImage(named:"player_btn_pre_normal"), for: UIControlState.normal)
        upButton.addTarget(self, action: #selector(MusicViewController.upClick), for: UIControlEvents.touchUpInside)
        
        let nextButton = UIButton()
        nextButton.frame = CGRect.init(x: screenBounds.width - 90, y: 45, width: 40, height: 40)
        nextButton.setImage(UIImage(named:"player_btn_next_normal"), for: UIControlState.normal)
        nextButton.addTarget(self, action: #selector(MusicViewController.nextClick), for: UIControlEvents.touchUpInside)
        
      
       
        var ar = ["player_btn_favorite_normal","player_btn_repeat_normal","player_btn_download_normal","player_btn_share_normal","player_btn_playlist_normal"]
       
         let wid:Int = (Int)(screenBounds.width) / 6
        

        for i in 2 ..< 7 {
            let Button = UIButton()
            Button.frame = CGRect.init(x: (wid+5) * (i-1) - 30, y: 100, width: 50, height: 50)
            Button.tag = 101 + i
            Button.setImage(UIImage(named:ar[i-2]), for: UIControlState.normal)
            Button.addTarget(self, action:#selector(downClick(_:)), for: UIControlEvents.touchUpInside)
            playView.addSubview(Button)
        }
        
         playView.addSubview(startTime)
         playView.addSubview(overTime)
         playView.addSubview(slider)
         playView.addSubview(playButton)
         playView.addSubview(upButton)
         playView.addSubview(nextButton)
        
    }
    //底部第一个按钮
    func favoriteButton(_ btn:UIButton){
  
    }
    // _backToTopButton.hidden = scrollView.contentOffset.y > 100 ? NO : YES;
// MARK: - 底部5个按钮
    func downClick(_ btn:UIButton){
        switch btn.tag {
        case 103:
            let model = self.dataArr[self._index] as! firstModel
            print(model)
            if isFavorite == false{
                btn.setImage(UIImage(named:"player_btn_favorited_normal"), for: UIControlState.normal)
                isFavorite = true
                DBManager.shareInstance.insertLove(model: model)
            }else{
                btn.setImage(UIImage(named:"player_btn_favorite_normal"), for: UIControlState.normal)
                isFavorite = false
                DBManager.shareInstance.deleteLoveForTrackId(trackId: String(format:"%@",model.trackId))
                //DBManager.shareInstance.deleteAllLove()
            }
            break
        case 104:
            //player_btn_repeatone_normal@2x
            if isList == true{
                btn.setImage(UIImage(named:"player_btn_repeatone_normal"), for: UIControlState.normal)
                isList = false
            }else{
             btn.setImage(UIImage(named:"player_btn_repeat_normal"), for: UIControlState.normal)
                isList = true
            }
            print("")
            break
        case 105:
            //下载
            if downClouser != nil{
                let model = dataArr[_index]
               downClouser!(model as! firstModel)
            }
            break
        case 106:
            print("分享")
            break
        case 107:
            print("列表")
            break
            
        default:
            break
        }
    }
    //切换品质
    func sqClike(_ btn:UIButton) {
        if sqButton.tag == 2{
            sqButton.tag = 1
          sqButton.setImage(UIImage(named:"player_btn_bz_sel_normal"), for: UIControlState.normal)
            self.play(urlStr: infoModel.playUrl32 as NSString)
        }else{
            sqButton.tag = 2
        sqButton.setImage(UIImage(named:"player_btn_hq_sel_normal"), for: UIControlState.normal)
            self.play(urlStr: infoModel.playUrl64 as NSString)
        }
       
        
    }
    func btnClick(button:UIButton) {
        
    }
    
    func popClick(){
        UIView.animate(withDuration: 0.3, animations: {() in
            self.titleView.frame = CGRect.init(x: 0, y: -150, width: self.screenBounds.width, height: 150)
            self.titleView.alpha = 0.5
            self.playView.frame = CGRect.init(x: 0, y: self.screenBounds.height + 150, width: self.screenBounds.width, height: 150)
            self.playView.alpha = 0.5
           
            self.view.alpha = 0
            
        }, completion: { (finshed:Bool) in
            
        })
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 10, options: UIViewAnimationOptions.allowUserInteraction, animations: {() in
            
            self.roundImageView.frame = CGRect(x:5,y:self.screenBounds.height-5,width:30,height:30)
            self.playBackimage.frame = CGRect(x:5,y:self.screenBounds.height-5,width:30,height:30)
            
            }, completion: {(finshed:Bool) in
                
                  })
        
          self.detail1.showNavigation()
          self.downVC.showNavigation()
          self.favorite.showNavigation()
        
        
        }
 //传歌曲列表过来
    func resiveArr(arr:NSMutableArray,index:Int,detail:UIViewController)  {
        dataArr = NSMutableArray.init(array: arr)
        self._index = index
        if detail .isKind(of: DetailViewController.classForCoder()){
          self.detail1 = detail as! DetailViewController
        }else if (detail.isKind(of: FavoriteViewController.classForCoder())){
          self.favorite = detail as! FavoriteViewController
        }else{
          self.downVC = detail as! DownViewController
        }
       
        self.setTabBarInfo(arr:dataArr,index:_index)
    }
    //设置tabBar的属性
    func setTabBarInfo(arr:NSMutableArray, index:Int){
        let nowModel = arr[index] as! firstModel
        nowModel.nickname = self.nickName
        tabbar.titleLabel.text = nowModel.title
        tabbar.nameLabel.text = nowModel.nickname
        tabbar.logoImageView.sd_setImage(with: NSURL.init(string: nowModel.coverSmall) as URL!)
        tabbar.view.isHidden = false
        if index > 0{
           let upIndex = index - 1
        let upModel = arr[upIndex] as! firstModel
            tabbar.titleLabel2.text = upModel.title
            tabbar.nameLabel2.text = self.nickName
            tabbar.logoImageView2.sd_setImage(with: NSURL.init(string: upModel.coverSmall) as URL!)
            
        }
        if index <  dataArr.count - 1{
            let nextIndex = index + 1
            let nextModel = arr[nextIndex] as! firstModel
            tabbar.titleLabel3.text = nextModel.title
            tabbar.nameLabel3.text = self.nickName
            tabbar.logoImageView3.sd_setImage(with: NSURL.init(string: nextModel.coverSmall) as URL!)
        }
    }
// 暂停后保存上次播放记录
    func saveInfo(){
    UserDefaults.standard.set(infoModel.title, forKey: "title")
    UserDefaults.standard.set(infoModel.coverLarge, forKey: "image")
    UserDefaults.standard.set(self.slider.value, forKey: "progress")
    UserDefaults.standard.set(infoModel.playUrl64, forKey: "url")
        
    }
// MARK: - 播放按钮事件
    func playClick() {
        //播放按钮事件
        if isPlay == true{
         isPlay = false
            playButton.setImage(UIImage(named:"player_btn_play_normal"), for: UIControlState.normal)
        self.tabbar.playButton.setImage(UIImage(named:"miniplayer_btn_play_normal"), for: UIControlState.normal)
            AFSoundManager.shared().pause()
          //  self.saveInfo()
            self.pauseAnimation(imageV: self.roundImageView)
            self.pauseAnimation(imageV: tabbar.logoImageView)
            
        }else{
            playButton.setImage(UIImage(named:"player_btn_pause_normal"), for: UIControlState.normal)
            self.tabbar.playButton.setImage(UIImage(named:"miniplayer_btn_pause_normal"), for: UIControlState.normal)
            isPlay = true
            AFSoundManager.shared().resume()
            self.contiuneAnimation(imageV: self.roundImageView)
            self.contiuneAnimation(imageV: tabbar.logoImageView)
        
        }
        
    }
    //切换歌曲
    func chageClick(index:Int){
        let model:firstModel = dataArr[index] as! firstModel
        self.infoModel = model
        self.titleLabel.text = model.title
        let width:CGFloat = getLabWidth(labelStr: model.title, font: UIFont.systemFont(ofSize: 17), height: 20)
        self.titleLabelScrollView.contentOffset.x = 0
        titleLabelScrollView.contentSize = CGSize.init(width: width * 2, height: 30)
        isWidth = width
        self.titleLabel.frame = CGRect.init(x: 0, y: 5, width: width, height: 20)
        self.titleLabel2.frame = CGRect.init(x: width, y: 5, width: width, height: 20)
        self.titleLabel.text = model.title
        self.titleLabel2.text = model.title
        self.titleLabelScrollView.layer.removeAllAnimations()
        self.singerLabel.text = String(format:" ——  %@  —— ",self.nickName)
        roundImageView2.sd_setImage(with:NSURL.init(string:model.coverLarge) as URL?, completed: {(image: UIImage?, error: Error?, cacheType: SDImageCacheType, imageURL: URL?) in
            UIGraphicsBeginImageContextWithOptions((image?.size)!, false, 0.0)
            let radius = min((image?.size.width)!, (image?.size.height)!) * 0.5
            let width = radius * 2
            let height = width
            let rect = CGRect.init(x: 0, y: 0, width: width, height: height)
            let rect1 = rect.insetBy(dx: 25 ,dy: 25)
            //let rect = self.screenBounds.insetBy(dx: width, dy: height)
            let bezierPath = UIBezierPath.init(ovalIn: rect1)
            bezierPath.lineWidth = 30
            UIColor(red: 0.14, green: 0.10, blue: 0.08, alpha: 0.7).setStroke()
            bezierPath.stroke()
            bezierPath.fill()
            bezierPath.addClip()
            image?.draw(in: rect)
            let resImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.roundImageView2.image = resImage
        })
        UIView.animate(withDuration: 0.3, animations: {() in
            self.roundImageView.frame.size = CGSize.init(width: 320, height: 320)
            
            
        }, completion: {(finshed:Bool) in
            
            UIView.animate(withDuration: 0.3, animations: {()  in
                self.roundImageView.frame  = CGRect(x:self.screenBounds.width/2 - 170,y: -300,width:300,height:300)
                self.roundImageView.alpha = 0.3
                self.roundImageView2.alpha = 1
            }, completion: {(finshed:Bool) in
                
                self.perform(#selector(MusicViewController.exchangeClick), with: nil, afterDelay: 1)
                self.bgView.sd_setImage(with:NSURL.init(string:model.coverLarge) as URL?)
                
            })
           
        })
            self.play(urlStr: model.playUrl64 as NSString)
    }
    
    func upClick() {
        //上一曲
            if _index >  0{
            _index -= 1
            self.chageClick(index: _index)
            self.setTabBarInfo(arr: self.dataArr, index: _index)
        }
    }
    func nextClick() {
        //下一曲
        if _index <  dataArr.count - 1{
            _index += 1
            self.chageClick(index: _index)
            self.setTabBarInfo(arr: self.dataArr, index: _index)
        }
    }
    func exchangeClick() {
        let model:firstModel = dataArr[_index] as! firstModel
        roundImageView.sd_setImage(with:NSURL.init(string:model.coverLarge) as URL?, completed: {(image: UIImage?, error: Error?, cacheType: SDImageCacheType, imageURL: URL?) in
            UIGraphicsBeginImageContextWithOptions((image?.size)!, false, 0.0)
            let radius = min((image?.size.width)!, (image?.size.height)!) * 0.5
            let width = radius * 2
            let height = width
            let rect = CGRect.init(x: 0, y: 0, width: width, height: height)
            let rect1 = rect.insetBy(dx: 25 ,dy: 25)
            //let rect = self.screenBounds.insetBy(dx: width, dy: height)
            let bezierPath = UIBezierPath.init(ovalIn: rect1)
            bezierPath.lineWidth = 30
            UIColor(red: 0.14, green: 0.10, blue: 0.08, alpha: 0.7).setStroke()
            bezierPath.stroke()
            bezierPath.fill()
            bezierPath.addClip()
            image?.draw(in: rect)
            let resImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.roundImageView.image = resImage
        })
        self.roundImageView.alpha = 1
        self.roundImageView.frame = CGRect(x:self.screenBounds.width/2 - 170,y:self.screenBounds.height/2 - 200,width:340,height:340)
        self.roundImageView2.alpha = 0
        self.startAnimation()
    }
    
    func backOrForwardAudio() {
       AFSoundManager.shared().move(toSection:CGFloat(slider.value))
       tabbar.playProgressView?.progressValue = slider.value
       tabbar.playProgressView?.changeSliderValue()
    }
    
//MARK: - 播放网络
    func play(urlStr:NSString) {
       //(^progressBlock)(int percentage, CGFloat elapsedTime, CGFloat timeRemaining, NSError *error, BOOL finished)
        AFSoundManager.shared().startStreamingRemoteAudio(fromURL:urlStr as String!, andBlock:{(percentage,elapsedTime:CGFloat,timeRemaining:CGFloat,_,_) in
            self.setLockView(current: elapsedTime,totalTime:elapsedTime + timeRemaining)
            self.slider.value = Float(percentage) * 0.01
            let formatter = DateFormatter()
            formatter.dateFormat = "mm:ss"
            let startTimeData = NSDate.init(timeIntervalSince1970: TimeInterval(elapsedTime))
            self.startTime.text = formatter.string(from: startTimeData as Date)
            let timeRemainingDate = NSDate.init(timeIntervalSince1970: TimeInterval(timeRemaining))
            self.overTime.text = formatter.string(from: timeRemainingDate as Date)
            if (self.overTime.text == "00:00")&&(self.isList == true){
                self.nextClick()
            }else if (self.overTime.text == "00:00")&&(self.isList == false){
               AFSoundManager.shared().restart()
            }
            
            if self.isPlay == true{
            self.playButton.setImage(UIImage(named:"player_btn_pause_normal"), for: UIControlState.normal)
            self.tabbar.playButton.setImage(UIImage(named:"miniplayer_btn_pause_normal"), for: UIControlState.normal)
            }
            
        })
        
    }
//MARK: - 播放本地音乐
    func playLocation(urlStr:NSString){
        
        let doc = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        print(doc)
        
        AFSoundManager.shared().startPlayingLocalFile(withName: String(format:"/%@.mp3",urlStr.md5Hash()), atPath: doc, withCompletionBlock: {(percentage,elapsedTime:CGFloat,timeRemaining:CGFloat,_,_) in
            self.slider.value = Float(percentage) * 0.01
            let formatter = DateFormatter()
            formatter.dateFormat = "mm:ss"
            let startTimeData = NSDate.init(timeIntervalSince1970: TimeInterval(elapsedTime))
            self.startTime.text = formatter.string(from: startTimeData as Date)
            let timeRemainingDate = NSDate.init(timeIntervalSince1970: TimeInterval(timeRemaining))
            self.overTime.text = formatter.string(from: timeRemainingDate as Date)
            if (self.overTime.text == "00:00")&&(self.isList == true){
                self.nextClick()
            }else if (self.overTime.text == "00:00")&&(self.isList == false){
                AFSoundManager.shared().restart()
            }
            
            
            if self.isPlay == true{
                self.playButton.setImage(UIImage(named:"player_btn_pause_normal"), for: UIControlState.normal)
                self.tabbar.playButton.setImage(UIImage(named:"miniplayer_btn_pause_normal"), for: UIControlState.normal)
                
            }
        })
    }
    
    
    //同步slider
    func timerClick() {
        tabbar.playProgressView?.progressValue = slider.value
        tabbar.playProgressView?.changeSliderValue()
        
    }
    //暂停动画
    func pauseAnimation(imageV:UIImageView){
        let pausedTime = imageV.layer.convertTime(CACurrentMediaTime(), from: nil)
        imageV.layer.speed = 0.0
        imageV.layer.timeOffset = pausedTime
    }
    //继续动画
    func contiuneAnimation(imageV:UIImageView){
        //重启动画
        let pausedTime = imageV.layer.timeOffset
        imageV.layer.speed = 1.0
        imageV.layer.timeOffset = 0.0
        imageV.layer.beginTime = 0.0
        let timeSincePause = imageV.layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        imageV.layer.beginTime = timeSincePause
        
    }
    
    func startAnimation(){
        let rotationAnimation:CABasicAnimation = CABasicAnimation.init(keyPath: "transform.rotation.z")
        let toValue = NSNumber.init(value: M_PI * 2.0)
        rotationAnimation.toValue = toValue
        roundImageView.layer.speed = 1.0
        tabbar.logoImageView.layer.speed = 1.0
        rotationAnimation.duration = 20;
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = 999999
        rotationAnimation.isRemovedOnCompletion = false
        roundImageView.layer.add(rotationAnimation, forKey: "rotationAnimation")
        tabbar.logoImageView.layer.add(rotationAnimation, forKey: "rotationAnimation")
    
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    
    }
    //改变歌曲
    func changeMusicInfo(str:String){
        //浏览记录
        
        
        let width:CGFloat = getLabWidth(labelStr: infoModel.title, font: UIFont.systemFont(ofSize: 17), height: 20)
        self.titleLabelScrollView.contentOffset.x = 0
        titleLabelScrollView.contentSize = CGSize.init(width: width * 2, height: 30)
        isWidth = width
        self.titleLabel.frame = CGRect.init(x: 0, y: 5, width: width, height: 20)
        self.titleLabel2.frame = CGRect.init(x: width, y: 5, width: width, height: 20)
        self.titleLabel.text = infoModel.title
        self.titleLabel2.text = infoModel.title
        self.singerLabel.text = String(format:" ——  %@  —— ",self.nickName)
        self.setRoundImage()
        self.setRoundImage2()
        self.isPlay = true
        if str == "location"{
            AFSoundManager.shared().stop()
         self.playLocation(urlStr: infoModel.playUrl64 as NSString)
        }else{
            AFSoundManager.shared().stop()
         self.play(urlStr: infoModel.playUrl64 as NSString)
        }
        
        self.startAnimation()
    }
    //之所以分开写是因为防止代码重复
    func setRoundImage(){
        roundImageView.sd_setImage(with:NSURL.init(string:infoModel.coverLarge) as URL?, completed: {(image: UIImage?, error: Error?, cacheType: SDImageCacheType, imageURL: URL?) in
            let artwork = MPMediaItemArtwork.init(image: image!)
            self.musicDict.setObject(artwork, forKey: MPMediaItemPropertyArtwork as NSCopying)
            UIGraphicsBeginImageContextWithOptions((image?.size)!, false, 0.0)
            let radius = min((image?.size.width)!, (image?.size.height)!) * 0.5
            let width = radius * 2
            let height = width
            let rect = CGRect.init(x: 0, y: 0, width: width, height: height)
            let rect1 = rect.insetBy(dx: 25 ,dy: 25)
            //let rect = self.screenBounds.insetBy(dx: width, dy: height)
            let bezierPath = UIBezierPath.init(ovalIn: rect1)
            bezierPath.lineWidth = 30
            UIColor(red: 0.14, green: 0.10, blue: 0.08, alpha: 0.7).setStroke()
            bezierPath.stroke()
            bezierPath.fill()
            bezierPath.addClip()
            
            image?.draw(in: rect)
            let resImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.roundImageView.image = resImage
        })
    }
    func setRoundImage2(){
        roundImageView2.sd_setImage(with:NSURL.init(string:infoModel.coverLarge) as URL?, completed: {(image: UIImage?, error: Error?, cacheType: SDImageCacheType, imageURL: URL?) in
            UIGraphicsBeginImageContextWithOptions((image?.size)!, false, 0.0)
            let radius = min((image?.size.width)!, (image?.size.height)!) * 0.5
            let width = radius * 2
            let height = width
            let rect = CGRect.init(x: 0, y: 0, width: width, height: height)
            let rect1 = rect.insetBy(dx: 25 ,dy: 25)
            //let rect = self.screenBounds.insetBy(dx: width, dy: height)
            let bezierPath = UIBezierPath.init(ovalIn: rect1)
            bezierPath.lineWidth = 30
            UIColor(red: 0.14, green: 0.10, blue: 0.08, alpha: 0.7).setStroke()
            bezierPath.stroke()
            bezierPath.fill()
            bezierPath.addClip()
            
            image?.draw(in: rect)
            let resImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.roundImageView2.image = resImage
        })
    }
    func startKeyAnimaiton() {
        let rectLayer2 = titleLabel.layer
        rectLayer2.position.x = titleLabel.frame.origin.x + 100
        let rectRunAnimation = CABasicAnimation.init(keyPath: "position")
        rectRunAnimation.fromValue = NSValue.init(cgPoint: rectLayer2.position)
        var toPoint = rectLayer2.position
        toPoint.x += 300
        rectRunAnimation.toValue = toPoint
        rectRunAnimation.autoreverses = true
        rectRunAnimation.duration = 10
        rectRunAnimation.repeatCount = Float(NSNotFound)
        rectRunAnimation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseOut)
        rectLayer2 .add(rectRunAnimation, forKey: "animationPosition")
    
    }}

   func getLabWidth(labelStr:String,font:UIFont,height:CGFloat) -> CGFloat {
    
    let statusLabelText: NSString = labelStr as NSString
    
    let size = CGSize.init(width: 900, height: height)
    
    let dic = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
    
    let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [String : AnyObject], context: nil).size
    
    return strSize.width
    
}
