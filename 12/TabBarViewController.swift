//
//  TabBarViewController.swift
//  12
//
//  Created by 王吉吉 on 2016/11/30.
//  Copyright © 2016年 王喆. All rights reserved.
//

import UIKit

class TabBarViewController: UIViewController,UIScrollViewDelegate {
    //单例
 static let TabBar = TabBarViewController()
   // var music = MusicViewController()
    var bottomView = UIScrollView()
    var logoImageView = UIImageView()
    var logoImageView2 = UIImageView()
    var logoImageView3 = UIImageView()
    var titleLabel = UILabel()
    var nameLabel = UILabel()
    var titleLabel2 = UILabel()
    var nameLabel2 = UILabel()
    var titleLabel3 = UILabel()
    var nameLabel3 = UILabel()
    var playButton = UIButton()
    var playProgressView:WZProgressView?
    var listButton = UIButton()
    //毛玻璃
    var visualeffectview = UIVisualEffectView()
    var blureffect = UIBlurEffect()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        self.creatUI()
    }
    
    func creatUI(){
        //毛玻璃
        self.blureffect = UIBlurEffect.init(style: UIBlurEffectStyle.extraLight)
        self.visualeffectview = UIVisualEffectView.init(effect: self.blureffect)
        self.visualeffectview.frame = CGRect.init(x: 0, y: 0, width: screenBounds.width, height: screenBounds.height)
        self.visualeffectview.alpha = 0.995

        self.view.addSubview(self.visualeffectview)
        
       let lineView = UIView()
        lineView.backgroundColor = UIColor.init(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        lineView.frame = CGRect.init(x: 0, y: 0, width: screenBounds.width, height: 0.5)
        self.view.addSubview(lineView)
        
       bottomView.frame = CGRect.init(x: 0, y: 0, width: screenBounds.width * 0.8, height: 40)
       bottomView.contentSize = CGSize.init(width: screenBounds.width * 2.4, height: 40)
       bottomView.showsHorizontalScrollIndicator = false;
       bottomView.contentOffset.x = screenBounds.width * 0.8
        bottomView.isPagingEnabled = true
        bottomView.delegate = self
       bottomView.backgroundColor = UIColor.clear
       self.view.addSubview(bottomView)
        //给 bottomView加手势
        let ges = UITapGestureRecognizer.init(target: self, action:#selector(TabBarViewController.gesClick))
        self.bottomView.addGestureRecognizer(ges)
        
        // imageview
        logoImageView.frame = CGRect.init(x: 5 + screenBounds.width * 0.8, y: 2, width: 36, height: 36)
        logoImageView.sd_setImage(with: nil, placeholderImage: UIImage(named:"me"))
        logoImageView.layer.cornerRadius = logoImageView.frame.width/2
        logoImageView.layer.masksToBounds = true
        bottomView.addSubview(logoImageView)
        //名字
        titleLabel.frame = CGRect.init(x: 45 + screenBounds.width * 0.8, y: 5, width: screenBounds.width * 0.7, height: 12)
        titleLabel.text = "北京东路的日子"
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        bottomView.addSubview(titleLabel)
        //专辑
        nameLabel.frame = CGRect.init(x: 45 + screenBounds.width * 0.8, y: 22, width: 100, height: 12)
        nameLabel.text = "群星"
        nameLabel.textColor = UIColor.gray
        nameLabel.font = UIFont.systemFont(ofSize: 12)
        bottomView.addSubview(nameLabel)
        
        
        // 左侧ImageView
        logoImageView2.frame = CGRect.init(x: 5, y: 2, width: 36, height: 36)
        logoImageView2.sd_setImage(with: nil, placeholderImage: UIImage(named:"me"))
        logoImageView2.layer.cornerRadius = logoImageView.frame.width/2
        logoImageView2.layer.masksToBounds = true
        bottomView.addSubview(logoImageView2)
        //名字
        titleLabel2.frame = CGRect.init(x: 45, y: 5, width: screenBounds.width * 0.7, height: 12)
        titleLabel2.text = "北京东路的日子"
        titleLabel2.textColor = UIColor.black
        titleLabel2.font = UIFont.systemFont(ofSize: 12)
        bottomView.addSubview(titleLabel2)
        //专辑
        nameLabel2.frame = CGRect.init(x: 45, y: 22, width: 100, height: 12)
        nameLabel2.text = "群星"
        nameLabel2.textColor = UIColor.gray
        nameLabel2.font = UIFont.systemFont(ofSize: 12)
        bottomView.addSubview(nameLabel2)
        
        
        // 右侧ImageView
        logoImageView3.frame = CGRect.init(x: 5 + screenBounds.width * 1.6, y: 2, width: 36, height: 36)
        logoImageView3.sd_setImage(with: nil, placeholderImage: UIImage(named:"me"))
        logoImageView3.layer.cornerRadius = logoImageView.frame.width/2
        logoImageView3.layer.masksToBounds = true
        bottomView.addSubview(logoImageView3)
        //名字
        titleLabel3.frame = CGRect.init(x: 45 + screenBounds.width * 1.6, y: 5, width: screenBounds.width * 0.7, height: 12)
        titleLabel3.text = "北京东路的日子"
        titleLabel3.textColor = UIColor.black
        titleLabel3.font = UIFont.systemFont(ofSize: 12)
        bottomView.addSubview(titleLabel3)
        //专辑
        nameLabel3.frame = CGRect.init(x: 45 + screenBounds.width * 1.6, y: 22, width: 100, height: 12)
        nameLabel3.text = "群星"
        nameLabel3.textColor = UIColor.gray
        nameLabel3.font = UIFont.systemFont(ofSize: 12)
        bottomView.addSubview(nameLabel3)
        
        //播放按钮
        playButton.setImage(UIImage(named:"miniplayer_btn_play_normal"), for: UIControlState.normal)
        playButton.frame = CGRect.init(x: screenBounds.width - 76.5, y: 2, width: 32, height: 32)
        playButton.addTarget(self, action: #selector(TabBarViewController.miniPlayClick), for: UIControlEvents.touchUpInside)
        self.view.addSubview(playButton)
        
        let imageV = UIImageView()
        imageV.backgroundColor = UIColor.clear
        imageV.frame = CGRect.init(x: screenBounds.width - 75, y: 4, width: 28, height: 28)
        imageV.layer.cornerRadius = 14
        imageV.layer.masksToBounds  = true
        imageV.layer.borderWidth = 1
        imageV.layer.borderColor = UIColor.init(red: 0.19, green: 0.76, blue: 0.49, alpha: 1).cgColor
        self.view.addSubview(imageV)
        
      
        playProgressView = WZProgressView.init(frame: CGRect.init(x: screenBounds.width - 75, y: 4, width: 28, height: 28), back: UIColor.clear, progressColor: UIColor.init(red: 0.19, green: 0.76, blue: 0.49, alpha: 1), lineWidth: 2)
        self.view.addSubview(playProgressView!)
        //播放按钮手势,button 太小
        let playTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(TabBarViewController.miniPlayClick))
        playProgressView!.addGestureRecognizer(playTapGesture)
        
        // 列表按钮
        listButton.setImage(UIImage(named:"miniplayer_btn_playlist_normal"), for: UIControlState.normal)
        listButton.frame = CGRect.init(x: screenBounds.width - 35, y: 20 - 15, width: 30, height: 30)
        listButton.addTarget(self, action: #selector(TabBarViewController.listClick), for: UIControlEvents.touchUpInside)
        self.view.addSubview(listButton)
        
    }
    //手势
    func gesClick(){
     let music = MusicViewController.music
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
    
    func miniPlayClick(){
    let music = MusicViewController.music
        music.playClick()
    }
    func listClick(){
        
    }
    
    
   
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let music = MusicViewController.music
        let x = scrollView.contentOffset.x
        print(x)
        if x < screenBounds.width * 0.7{
            music.upClick()
            self.exchange()
       }else if x > screenBounds.width * 1.2 {
            music.nextClick()
            self.exchange()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        print(x)
        if x < 300{
           
        }else if x > 300 {
          
        }
    }
    
    func exchange(){
        self.logoImageView.layer.removeAllAnimations()
        bottomView.contentOffset.x = screenBounds.width * 0.8
    }
    
}
