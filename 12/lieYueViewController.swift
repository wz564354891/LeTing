//
//  lieYueViewController.swift
//  12
//
//  Created by 王吉吉 on 2016/12/28.
//  Copyright © 2016年 王喆. All rights reserved.
//

import UIKit
import Alamofire
class lieYueViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var tableView = UITableView()
    var dataArr = NSMutableArray()
    var tabDataArr = NSMutableArray()
    var listenArr = NSMutableArray()
    var height = CGFloat()
    var selectIndex = NSInteger()
    var urlStr = "http://wawa.fm:9090/wawa/api.php/magazine/magazinelist/r/10/page/1"
    override func viewDidLoad() {
        super.viewDidLoad()
        height = 250
      self.creatUI()
        self.initNet()
    }
    func initNet(){
        Alamofire.request(urlStr, method: .get).responseJSON {
            response in
            switch response.result{
            case.success:
            var arr = NSArray.init()
            arr = response.result.value as! NSArray
            for dict2 in arr{
                let model = firstModel()
                model.setValuesForKeys((dict2 as! NSDictionary) as! [String : Any])
                self.dataArr.add(model)
                
                //第二层
                let dict3 = dict2 as! NSDictionary
                let ar = dict3.object(forKey: "tracks") as! NSArray
                for dict4 in ar{
                  let model = zhiboModel()
                    model.setValuesForKeys((dict4 as! NSDictionary) as! [String : Any])
                    self.tabDataArr.add(model)
                }
                //第三层
                let ar2 = dict3.object(forKey: "listen") as! NSArray
                for dict5 in ar2{
                 let model = zhiboModel()
                    model.setValuesForKeys((dict5 as! NSDictionary) as! [String : Any])
                   self.listenArr.add(model)
                }
            }
            self.tableView.reloadData()
            case.failure(let error):
                print(error)
                
            }
        }
    }
    func creatUI(){
        self.tableView.frame = self.view.frame
        self.tableView.fd_debugLogEnabled = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 250
        self.tableView.register(LieYueCell.classForCoder(), forCellReuseIdentifier: "lieyue")
        self.view.addSubview(self.tableView)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print(indexPath.row)
        if indexPath.row == selectIndex{
            return self.height
        }
        return 250
        
    }
    
    func configureCell(cell:LieYueCell,indexPath:NSIndexPath){
      cell.fd_enforceFrameLayout = true
        
        let model = self.dataArr[indexPath.row] as! firstModel
        cell .showDataWithModel(model: model,tabArr:self.tabDataArr,listenArr:self.listenArr,indexPath: indexPath as NSIndexPath)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lieyue", for: indexPath) as! LieYueCell
        self.configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
    return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let cell = self.tableView.cellForRow(at: indexPath) as! LieYueCell
        cell.tanchuClouseres = {(height,tyCell) in
            self.tableView.beginUpdates()
            var oldFrame = cell.frame
            oldFrame.size.height = height
            cell.frame = oldFrame
            self.tableView.endUpdates()
        }
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

  }
