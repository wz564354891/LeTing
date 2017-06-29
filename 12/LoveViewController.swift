//
//  FavoriteViewController.swift
//  12
//
//  Created by 王吉吉 on 2016/12/19.
//  Copyright © 2016年 王喆. All rights reserved.
//

import UIKit

class LoveViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    var tableView = UITableView()
    var dataArr = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的喜欢"
        self.creatUI()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        let arr = DBManager.shareInstance.readLoveModels()
        let arr1 = arr.reverseObjectEnumerator().allObjects
        dataArr = NSMutableArray.init(array: arr1)
        self.tableView.reloadData()
    }
    func creatUI(){
        tableView = UITableView.init(frame: CGRect.init(x: 0, y:0, width: screenBounds.width, height: screenBounds.height), style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 65
        tableView.register(UINib.init(nibName: "DetailCell", bundle: nil), forCellReuseIdentifier: "Detail")
        self.view.addSubview(tableView)
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.editButtonItem.image = UIImage(named:"btn_downloadalbum_delete_n")
        let item = UIBarButtonItem.init(image: UIImage(named:""), style: UIBarButtonItemStyle.plain, target: self, action: #selector(LoveViewController.deleteClick))
        self.navigationItem.rightBarButtonItem = item
        
    }
    func deleteClick(){
      let isE = self.tableView.isEditing
        self.tableView.setEditing(isE, animated: true)
    }
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        self.tableView.setEditing(!self.tableView.isEditing, animated: true)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let model = self.dataArr[indexPath.row] as! firstModel
        self.dataArr.removeObject(at: indexPath.row)
        print(model.trackId)
        DBManager.shareInstance.deleteLoveForTrackId(trackId: String(format:"%@",model.trackId))
        self.tableView.reloadData()
        self.tableView.setEditing(false, animated: true)
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
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
    
    deinit{
       print("释放")
    }
    
}


