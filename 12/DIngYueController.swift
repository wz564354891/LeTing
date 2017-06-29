//
//  DIngYueController.swift
//  12
//
//  Created by 王吉吉 on 2017/2/20.
//  Copyright © 2017年 王喆. All rights reserved.
//

import UIKit

class DIngYueController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var tableView = UITableView()
    var dataArr = NSMutableArray()
    var CommitLabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.readDB()
        self.creatUI()
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
        self.title = String(format:"我的电台 %d",self.dataArr.count)
        self.tableView.reloadData()
        
    }
    
    
    func creatUI(){
        tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: screenBounds.width, height: screenBounds.height), style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        tableView.tableFooterView = UIView()
        tableView.register(UINib.init(nibName: "FirstDetailCell", bundle: nil), forCellReuseIdentifier: "tab")
        self.view.addSubview(tableView)
        
        self.CommitLabel = UILabel.init(frame: CGRect.init(x: 0, y:screenBounds.height * 0.3, width: screenBounds.width, height: 20))
        self.CommitLabel.text = "暂无订阅"
        self.CommitLabel.font = UIFont.systemFont(ofSize: 18)
        self.CommitLabel.isHidden = true
        self.CommitLabel.textAlignment = NSTextAlignment.center
        self.view.addSubview(self.CommitLabel)
    
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
