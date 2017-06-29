//
//  FavoriteViewController.swift
//  12
//
//  Created by 王吉吉 on 2016/12/19.
//  Copyright © 2016年 王喆. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    var tableView = UITableView()
    var dataArr = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        let arr = DBManager.shareInstance.readBroweseModels()
       // NSArray* reversedArray = [[array reverseObjectEnumerator] allObjects];
        let arr1 = arr.reverseObjectEnumerator().allObjects
        dataArr = NSMutableArray.init(array: arr1)
         self.title = "最近收听"
         
      self.creatUI()
    
    }
    
    func creatUI(){
        tableView = UITableView.init(frame: CGRect.init(x: 0, y:0, width: screenBounds.width, height: screenBounds.height), style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 65
        tableView.register(UINib.init(nibName: "DetailCell", bundle: nil), forCellReuseIdentifier: "Detail")
        self.view.addSubview(tableView)
        
    }
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Detail", for: indexPath) as! DetailCell
        let showModel = self.dataArr[indexPath.row]
        
        cell .showDataWithModel(model: showModel as! firstModel, indexPath: indexPath as NSIndexPath)
        let musi = MusicViewController.music
        //cell回调
        cell.myDownClourse = {(downModel) in
            downModel.nickname = (showModel as! firstModel).nickname
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
            model.nickname = (showModel  as! firstModel).nickname
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
        music.nickName = model.nickname
        music.isLoad = false
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        //这个方法只执行一次
        _ = DetailViewController.myGlobal
        //区分本地和网络
        music.changeMusicInfo(str:"net")
        
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
