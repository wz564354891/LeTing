//
//  MVDownViewController.swift
//  12
//
//  Created by 王吉吉 on 2016/12/20.
//  Copyright © 2016年 王喆. All rights reserved.
//

import UIKit

class MVDownViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    static var mvDownVC = MVDownViewController()
    var tableView = UITableView()
    var dataArr = NSMutableArray()
    var countLabel = UILabel()
    var cellArr = NSMutableArray()
    var CommitLabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
       self.creatUI()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.dataArr.removeAllObjects()
        self.dataArr = NSMutableArray.init(array: DBManager.shareInstance.readMVDownloadModels())
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
        tableView.rowHeight = 53
        tableView.tableHeaderView = upView
        tableView.tableFooterView = UIView()
        tableView.register(UINib.init(nibName: "MVDownCell", bundle: nil), forCellReuseIdentifier: "MVDownCell")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "MVDownCell", for: indexPath) as! MVDownCell
        cellArr.add(cell)
        let model = dataArr[indexPath.row] as! firstModel
        cell.showDataWithModel(model: model, indexPath: indexPath as NSIndexPath)
        return cell
        
    }
    
}
