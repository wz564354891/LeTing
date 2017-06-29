//
//  ZhiBoViewController.swift
//  12
//
//  Created by 王吉吉 on 2016/12/20.
//  Copyright © 2016年 王喆. All rights reserved.
//

import UIKit
import Alamofire
class ZhiBoViewController: UIViewController ,UIScrollViewDelegate{
    var userInfo = "http://116.211.167.106/api/live/users?lc=0000000000000044&cc=TG0001&cv=IK3.8.20_Iphone&proto=7&idfa=607661BF-682F-4C1B-B37E-DE5BC1235384&idfv=352BA155-D3EB-43A9-A051-F4AD6C8A9013&devi=4ecd79c2f658485f02ca0f90bf7134bb6c458cac&osversion=ios_10.000000&ua=iPhone7_1&imei=&imsi=&uid=321977308&sid=204Jd8JhTXsddqNcBwQWlOR3YjMRM8KEOYaYtyEWxzYdrkBEHF&conn=wifi&mtid=45335cc3650efe0ad1f7976259cab033&mtxid=f483cd65ad17&logid=120,30,5&start=0&count=%@&id=%@&s_sg=0e4532e616abee2c033370a3353acf6e&s_sc=100&s_st=1482375121"
    var liveFirstModel = firstModel()
    var liveZhiBoModel = zhiboModel()
    var userArr = NSMutableArray()
    var headImageV = UIImageView()
    var userCountLabel = UILabel()
    //先加载100 防止内存爆炸
    var userImageCount = Int()
    var imaegV = UIImageView()
    var userScrollview = UIScrollView()
    var playerVC:IJKFFMoviePlayerController?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userImageCount = 100
        self.creatUI()
        self.initNet()
    }
    func initNet(){
        Alamofire.request(String(format:userInfo,String(format:"%d",userImageCount),liveZhiBoModel.id), method: .get).responseJSON {
            response in
            switch response.result{
            case.success:
            var dict = NSDictionary.init()
            dict = response.result.value as! NSDictionary
            if dict["users"] != nil{
            let arr :NSArray = dict["users"] as! NSArray
            for dict2 in arr{
                let model = firstModel()
                model.description1 = (dict2 as! NSDictionary).object(forKey: "description") as! String
                model.setValuesForKeys((dict2 as! NSDictionary) as! [String : Any])
                self.userArr.add(model)
            }
          
           self.updateUserImage()
                
        }
            case.failure(let error):
                print(error)
                
            }
    }}
    func updateUserImage(){
        self.userScrollview.contentSize = CGSize.init(width: self.userArr.count * 20, height: 20)
        for i in 0..<self.userArr.count{
          let imgV = UIImageView()
            imgV.frame = CGRect.init(x:i * (30 + 10), y: 0, width: 30, height: 30)
            let model = self.userArr[i] as! firstModel
            if model.portrait.contains("http"){
            }else{
                model.portrait = String(format:"http://img2.inke.cn/%@",model.portrait)
            }
            imgV.sd_setImage(with: NSURL.init(string:model.portrait) as URL!)
            imgV.layer.cornerRadius = 15
            imgV.layer.masksToBounds = true
            userScrollview.addSubview(imgV)
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x = ((Int)(scrollView.contentOffset.x))%50
        if x == 0{
            self.userImageCount += 100
           self.initNet()
            print(self.userImageCount/100)
        }
    }
    func showHeart(){
     let heart = XTLoveHeartView.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        self.view.insertSubview(heart, at: 3)
        let fountainSourece = CGPoint.init(x: self.view.frame.size.width - 50, y: self.view.bounds.size.height - 30 / 2.0 - 30)
        heart.center = fountainSourece
        heart.animate(in: self.view)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.showHeart()
    }
    func creatUI(){
        _ = Timer.scheduledTimer(timeInterval: 0.5, target: YYWeakProxy.init(target: self), selector: #selector(ZhiBoViewController.showHeart), userInfo: nil, repeats: true)
       self.view.backgroundColor = UIColor.white
        self.imaegV.frame = self.view.frame
        self.view.addSubview(self.imaegV)
        if liveFirstModel.portrait.contains("http"){
        }else{
            liveFirstModel.portrait = String(format:"http://img2.inke.cn/%@",liveFirstModel.portrait)
        }
        let imageUrl = NSURL.init(string: String(format:"%@",liveFirstModel.portrait))
        self.imaegV.sd_setImage(with: imageUrl as URL!)
        let url = NSURL.init(string: liveZhiBoModel.stream_addr)
        playerVC = IJKFFMoviePlayerController.init(contentURL: url as URL!, with: nil)
        playerVC?.prepareToPlay()
        playerVC?.view.frame = UIScreen.main.bounds
        self.view.insertSubview((playerVC?.view)!, at: 1)
        
        let upView = UIView()
        upView.frame = CGRect.init(x: 0, y: 20, width: screenBounds.width, height: 30)
        upView.backgroundColor = UIColor.clear
        self.view.insertSubview(upView, at: 3)
        
        let guanZhuView = UIView()
        guanZhuView.frame = CGRect.init(x: 5, y: 0, width: 110, height: 30)
        guanZhuView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        guanZhuView.layer.cornerRadius = 15
        guanZhuView.layer.masksToBounds = true
        upView.addSubview(guanZhuView)
        
        headImageV.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        headImageV.sd_setImage(with:imageUrl as URL!)
        headImageV.layer.cornerRadius = 15
        headImageV.layer.masksToBounds = true
        guanZhuView.addSubview(headImageV)
        
        let zbLabel = UILabel()
        zbLabel.frame = CGRect.init(x: headImageV.frame.maxX + 5, y: 0, width: 50, height: 15)
        zbLabel.text = "直播"
        zbLabel.font = UIFont.systemFont(ofSize: 11)
        zbLabel.textColor = UIColor.white
        guanZhuView.addSubview(zbLabel)
        
        self.userCountLabel.frame = CGRect.init(x: headImageV.frame.maxX + 5, y: 20, width: 50, height: 10)
        self.userCountLabel.textColor = UIColor.white
        self.userCountLabel.font = UIFont.systemFont(ofSize: 11)
        self.userCountLabel.text = String(format:"%@",liveZhiBoModel.online_users)
        guanZhuView.addSubview(self.userCountLabel)
        
        userScrollview.frame = CGRect.init(x:guanZhuView.frame.maxX + 15 , y: 0, width: screenBounds.width - guanZhuView.frame.maxX + 15, height: 30)
        userScrollview.contentSize = CGSize.init(width: 1, height: 20)
        userScrollview.delegate = self
        userScrollview.showsHorizontalScrollIndicator = false
        upView.addSubview(userScrollview)
        
        
        
        
        
        let btn = UIButton()
        btn.setImage(UIImage(named:"alertview_btn_close_highlight"), for: UIControlState.normal)
        btn.frame = CGRect.init(x: screenBounds.width - 60, y: screenBounds.height - 60, width: 50, height: 50)
        btn.addTarget(self, action: #selector(ZhiBoViewController.popClick), for: UIControlEvents.touchUpInside)
        self.view.insertSubview(btn, at: 3)
        
        let shareBtn = UIButton()
        shareBtn.setImage(UIImage(named:"alertview_btn_close_highlight"), for: UIControlState.normal)
        shareBtn.frame = CGRect.init(x: screenBounds.width - 120, y: screenBounds.height - 60, width: 50, height: 50)
        shareBtn.addTarget(self, action: #selector(ZhiBoViewController.popClick), for: UIControlEvents.touchUpInside)
        self.view.insertSubview(shareBtn, at: 3)
        
        let commitBtn = UIButton()
        commitBtn.setImage(UIImage(named:"alertview_btn_close_highlight"), for: UIControlState.normal)
        commitBtn.frame = CGRect.init(x: 10, y: screenBounds.height - 60, width: 50, height: 50)
        commitBtn.addTarget(self, action: #selector(ZhiBoViewController.popClick), for: UIControlEvents.touchUpInside)
        self.view.insertSubview(commitBtn, at: 3)
        
    }
    
    func popClick(){
      _ = self.navigationController?.popViewController(animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        playerVC?.pause()
        playerVC?.stop()
        playerVC?.shutdown()
        playerVC = nil
    }
    deinit {
        print("释放")
    }
}

/*
 http://116.211.167.106/api/live/users?lc=0000000000000044&cc=TG0001&cv=IK3.8.20_Iphone&proto=7&idfa=607661BF-682F-4C1B-B37E-DE5BC1235384&idfv=352BA155-D3EB-43A9-A051-F4AD6C8A9013&devi=4ecd79c2f658485f02ca0f90bf7134bb6c458cac&osversion=ios_10.000000&ua=iPhone7_1&imei=&imsi=&uid=321977308&sid=204Jd8JhTXsddqNcBwQWlOR3YjMRM8KEOYaYtyEWxzYdrkBEHF&conn=wifi&mtid=45335cc3650efe0ad1f7976259cab033&mtxid=f483cd65ad17&logid=120,30,5&start=0&count=20&id=1482372990372440&s_sg=0e4532e616abee2c033370a3353acf6e&s_sc=100&s_st=1482375121
 
 
 http://116.211.167.106/api/live/users?lc=0000000000000044&cc=TG0001&cv=IK3.8.20_Iphone&proto=7&idfa=607661BF-682F-4C1B-B37E-DE5BC1235384&idfv=352BA155-D3EB-43A9-A051-F4AD6C8A9013&devi=4ecd79c2f658485f02ca0f90bf7134bb6c458cac&osversion=ios_10.000000&ua=iPhone7_1&imei=&imsi=&uid=321977308&sid=204Jd8JhTXsddqNcBwQWlOR3YjMRM8KEOYaYtyEWxzYdrkBEHF&conn=wifi&mtid=45335cc3650efe0ad1f7976259cab033&mtxid=f483cd65ad17&logid=120,30,5&start=0&count=20&id=1482374762204907&s_sg=0e4532e616abee2c033370a3353acf6e&s_sc=100&s_st=1482375121
 
 
 */










