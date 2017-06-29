//
//  MVPLayController.swift
//  12
//
//  Created by 王吉吉 on 2016/11/25.
//  Copyright © 2016年 王喆. All rights reserved.


import UIKit
import SnapKit
import Alamofire

class MVPLayController: UIViewController,ZFPlayerDelegate,UITableViewDataSource,UITableViewDelegate {
    //属性
   var url = "http://www.buyao.tv/appapi/index.php?appkey=BYMUSICOFFVN0DtKGcebowgEPLtASJfBBn6iOTQ&ac=commentlist&id=%@&userid=(null)&page=0"
   var model = firstModel()
   var playerView = ZFPlayerView()
   var _playerModel:ZFPlayerModel?
   var isPlaying = Bool()
   var bottomView = UIView()
   var commitTableView:UITableView?
   var dataArr = NSMutableArray()
   var CommitLabel = UILabel()
   var time = Timer()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
       UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: true)
        self.navigationController?.navigationBar.isHidden = true
    }
   override func viewWillDisappear(_ animated: Bool) {
         UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: true)
    self.navigationController?.navigationBar.isHidden = false
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
     self.creatUI()
     self.initNet()
     self.creatTimer()
    }
    func creatTimer(){
      self.time = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(MVPLayController.timeClick), userInfo: nil, repeats: true)
        
    }
    func timeClick(){
       // let currnetTime = self.playerView.currentTime
       // print(currnetTime)
        
    }
     func initNet(){
        let commitUrl = String(format:url,model.id)
        Alamofire.request(commitUrl, method: .get).responseJSON {
            response in
            switch response.result{
            case.success:
                var dict = NSDictionary.init()
                dict = response.result.value as! NSDictionary
                let arr = dict["by_item"] as! NSArray
                for dict2 in arr{
                    let model = firstModel()
                    model.setValuesForKeys(dict2 as! [String : Any])
                    self.dataArr.add(model)
                }
                if self.dataArr.count == 0{
                   self.CommitLabel.isHidden = false
                }
                self.commitTableView?.reloadData()
                
            case.failure(let error):
                print(error)
                
            }
        }
    }
    func playerModel()->ZFPlayerModel{
        if (_playerModel == nil){
            _playerModel = ZFPlayerModel()
            _playerModel?.title = model.title
            _playerModel?.videoURL = NSURL.init(string: model.url)! as URL
            _playerModel?.placeholderImage = UIImage(named:"loading_bgView1")
            
        }
        return _playerModel!
    }
    func creatUI(){
        //初始化model
        _playerModel = ZFPlayerModel()
        _playerModel?.title = self.model.title
        _playerModel?.videoURL = NSURL.init(string: self.model.url)! as URL
        _playerModel?.placeholderImage = UIImage(named:"loading_bgView1")
        
        
        
       let topView = UIView()
        topView.backgroundColor = UIColor.black
        self.view.addSubview(topView)
        topView.snp.makeConstraints({(make) in
             make.top.left.right.equalToSuperview()
             make.height.equalTo(200)
        })
       // topView.frame = CGRect.init(x: 0, y: 0, width: screenBounds.width, height: 150)
        self.view.addSubview(self.playerView)
        self.playerView.snp.makeConstraints({(make) in
            make.top.equalTo(topView).offset(20)
            make.left.equalTo(topView)
            make.right.equalTo(topView)
            make.height.equalTo(self.playerView.snp.width).multipliedBy(9.0/16.0)
        })
       // self.playerView.frame = CGRect.init(x: 0, y: 20, width: screenBounds.width, height: 170)
        
         self.playerView.playerLayerGravity = ZFPlayerLayerGravity.resizeAspectFill
        
        let controlView = ZFPlayerControlView()
        self.playerView.controlView = controlView
        self.playerView.playerModel = self._playerModel
        self.playerView.delegate = self
        self.playerView.hasDownload = true
        self.playerView.hasPreviewView = true
        self.playerView.autoPlayTheVideo()
        self.bottomView.backgroundColor = UIColor.white
        
        self.view.addSubview(self.bottomView)
        self.bottomView.snp.makeConstraints({(make) in
            make.top.equalTo(self.playerView.snp.bottom)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
        })
        
        let infoView = UIView()
        infoView.backgroundColor = UIColor.white
        self.bottomView.addSubview(infoView)
        infoView.snp.makeConstraints({(make) in
            make.top.equalTo(self.bottomView).offset(10)
            make.left.equalTo(self.bottomView)
            make.right.equalTo(self.bottomView)
            make.height.equalTo(100)
        })
        //简介
        let jianjieLabel = UILabel()
        jianjieLabel.text = "简介"
        jianjieLabel.textColor = UIColor.black
        jianjieLabel.font = UIFont.systemFont(ofSize: 16)
        jianjieLabel.frame = CGRect.init(x: 5, y: 0, width: 50, height: 20)
        infoView.addSubview(jianjieLabel)
        //上横线
        let grayLine = UIView()
        grayLine.frame = CGRect.init(x: 0, y: 20, width: screenBounds.width, height: 1)
        grayLine.backgroundColor = UIColor.init(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
        infoView.addSubview(grayLine)
        
        //标题
        let titleLbel = UILabel()
        infoView.addSubview(titleLbel)
        titleLbel.textColor = UIColor.black
        titleLbel.font = UIFont.systemFont(ofSize: 13)
        titleLbel.numberOfLines = 0
        titleLbel.text = model.title
        titleLbel.snp.makeConstraints({(make) in
           make.top.equalTo(grayLine).offset(5)
           make.left.equalToSuperview().offset(5)
           make.right.equalToSuperview().offset(-5)
           make.height.equalTo(40)
        })
        //日期
        let dateLabel = UILabel()
        infoView.addSubview(dateLabel)
        dateLabel.textColor = UIColor.gray
//        let index = model.regtime.index(model.regtime.startIndex, offsetBy: 10)
//        let newDate:NSString = model.regtime.substring(to: index) as NSString
        let regitme = model.regtime as NSString
        let t:Double = regitme.doubleValue
        let date = NSDate.init(timeIntervalSince1970: t)
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        dateLabel.text = String(format: "%@",df.string(from: date as Date))
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.textAlignment = NSTextAlignment.left
        dateLabel.snp.makeConstraints({(make) in
            make.left.equalTo(titleLbel)
            make.right.equalTo(100)
            make.bottom.equalToSuperview().offset(-5)
        })
        //浏览数
        let viewsLabel = UILabel()
        infoView.addSubview(viewsLabel)
        viewsLabel.textColor = UIColor.black
        viewsLabel.text = String(format:"浏览数  %@",model.views)
        viewsLabel.font = UIFont.systemFont(ofSize: 14)
        viewsLabel.textAlignment = NSTextAlignment.right
        viewsLabel.snp.makeConstraints({(make) in
          make.right.equalToSuperview().offset(-5)
          make.bottom.equalToSuperview().offset(-5)
          make.width.equalTo(100)
        })
        //下横线
        let grayLineD = UIView()
        grayLineD.frame = CGRect.init(x: 0, y: 100, width: screenBounds.width, height: 1)
        grayLineD.backgroundColor = UIColor.init(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
        infoView.addSubview(grayLineD)
        
        //评论
        let headView = UIView()
        headView.frame.size = CGSize.init(width: screenBounds.width, height: 50)
        let commitLabel = UILabel()
        commitLabel.text = "评论"
        commitLabel.textColor = UIColor.black
        commitLabel.font = UIFont.systemFont(ofSize: 16)
        commitLabel.frame = CGRect.init(x: 10, y: 10, width: 50, height: 20)
        headView.addSubview(commitLabel)
        
        
        
        commitTableView = UITableView()
        self.bottomView.addSubview(commitTableView!)
        commitTableView?.delegate = self
        commitTableView?.dataSource = self
        commitTableView?.tableHeaderView = headView
        commitTableView?.tableFooterView = UIView()
        commitTableView?.snp.makeConstraints({(make) in
            make.top.equalTo(infoView.snp.bottom)
            make.bottom.equalTo(self.bottomView)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        })
        commitTableView?.register(UINib.init(nibName: "CommitCell", bundle: nil), forCellReuseIdentifier: "commit")
        
        self.CommitLabel = UILabel.init(frame: CGRect.init(x: 0, y:screenBounds.height * 0.7, width: screenBounds.width, height: 20))
        self.CommitLabel.text = "暂无评论"
        self.CommitLabel.font = UIFont.systemFont(ofSize: 18)
        self.CommitLabel.isHidden = true
        self.CommitLabel.textAlignment = NSTextAlignment.center
        self.view.addSubview(self.CommitLabel)
        
    }
    
    func zf_playerBackAction() {
        self.time.invalidate()
       _ =  self.navigationController?.popViewController(animated: true)
    }
    func zf_playerDownload(_ url: String!) {
        if DBManager.shareInstance.isExistMVDownloadForId(id: String(format:"%@",model.id)) == false{
            WZAlertView.showWithText(text: "正在下载MV")
            DBManager.shareInstance.insertMVDownload(model: model)
            let mvDown = MVDownViewController.mvDownVC
            mvDown.dataArr.add(model)
            mvDown.tableView.reloadData()
        }else{
            WZAlertView.showWithText(text: "该MV已下载过")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commit", for: indexPath) as! CommitCell
        let model = self.dataArr[indexPath.row]
        
        cell .showDataWithModel(model: model as! firstModel, indexPath: indexPath as NSIndexPath)
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
     //和OC里面dealloc方法一致
    deinit {
       self.playerView.resetPlayer()
    }

}
