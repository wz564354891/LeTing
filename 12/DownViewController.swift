//
//  DownViewController.swift
//  12
//
//  Created by 王吉吉 on 2016/12/13.
//  Copyright © 2016年 王喆. All rights reserved.
//

import UIKit

class DownViewController:UIViewController ,UITableViewDelegate,UITableViewDataSource{
    static var downVC = DownViewController()
    var navigatinView = UIView()
    var tableView = UITableView()
    var dataArr = NSMutableArray()
    var cellArr = NSMutableArray()
    var countLabel = UILabel()
    var CommitLabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.creatUI()
    
    }
    override func viewWillAppear(_ animated: Bool) {
        self.dataArr.removeAllObjects()
        self.dataArr = NSMutableArray.init(array: DBManager.shareInstance.readDownloadModels())
        if self.dataArr.count == 0{
        self.CommitLabel.isHidden = false
        }
        countLabel.text = String(format:"(%d)",self.dataArr.count)
    }
    func creatUI(){
    
        let upView = UIView()
        upView.frame = CGRect.init(x: 0, y: 0, width: screenBounds.width, height: 40)
        self.view.addSubview(upView)
        
        let startButton = UIButton()
        startButton.setTitle("全部暂停", for: UIControlState.normal)
        startButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        startButton.addTarget(self, action: #selector(startClick(_:)), for: UIControlEvents.touchUpInside)
        startButton.frame = CGRect.init(x: 10, y: 0, width: 100, height: 40)
          upView.addSubview(startButton)
        
         countLabel.frame = CGRect.init(x: startButton.frame.maxX, y: 0, width: 100, height: 40)
         countLabel.text = "()"
         upView.addSubview(countLabel)
        
        tableView = UITableView.init(frame: self.view.bounds, style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 70
        tableView.tableHeaderView = upView
        tableView.tableFooterView = UIView()
        tableView.register(UINib.init(nibName: "DownLoadCell", bundle: nil), forCellReuseIdentifier: "downCell")
        self.view.addSubview(tableView)
       
        self.CommitLabel = UILabel.init(frame: CGRect.init(x: 0, y:screenBounds.height * 0.3, width: screenBounds.width, height: 20))
        self.CommitLabel.text = "暂无下载"
        self.CommitLabel.font = UIFont.systemFont(ofSize: 18)
        self.CommitLabel.isHidden = true
        self.CommitLabel.textAlignment = NSTextAlignment.center
        self.view.addSubview(self.CommitLabel)
        
        
    }
    func startClick(_ btn:UIButton){
        if btn.currentTitle == "全部暂停"{
          btn.setTitle("全部开始", for: UIControlState.normal)
            for cell in cellArr{
                (cell as! DownLoadCell).stopDownLoad()
            }
            
        }else{
           btn.setTitle("全部暂停", for: UIControlState.normal)
            for cell in cellArr{
                (cell as! DownLoadCell).startDownload()
                
            }
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "downCell", for: indexPath) as! DownLoadCell
        cellArr.add(cell)
         let model = dataArr[indexPath.row] as! firstModel
         cell.showDataWithModel(model: model, indexPath: indexPath as NSIndexPath)
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let music = MusicViewController.music
        let model = self.dataArr[indexPath.row] as! firstModel
        music.resiveArr(arr: self.dataArr, index: indexPath.row,detail:self)
        music.infoModel = model
        music.nickName = model.nickname
        music.isLoad = false
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        //这个方法只执行一次
        _ = DetailViewController.myGlobal
        //区分本地和网络
        music.changeMusicInfo(str:"location")
        
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
    //闭包回调
    func showNavigation(){
        self.navigationController?.navigationBar.isHidden = false
    }
    static let myGlobal:() = {
        let music = MusicViewController.music
        UIApplication.shared.keyWindow?.addSubview(music.view)
    }()
}
