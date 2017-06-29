//
//  FourViewController.swift
//  12
//
//  Created by 王吉吉 on 2016/11/4.
//  Copyright © 2016年 王喆. All rights reserved.
//

import UIKit
import Alamofire
class FourViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var tableView = UITableView()
    var dataArr = NSMutableArray()
    var dataArr2 = NSMutableArray()
    var tabar = TabBarViewController.TabBar
    override func viewDidLoad() {
        super.viewDidLoad()
     self.creatUI()
        self.initUI()
       }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabar.view.isHidden = false
    self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    func creatUI(){
        self.tableView.frame = self.view.frame
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 420
        self.tableView.register(UINib.init(nibName: "ZhiBoCell", bundle: nil), forCellReuseIdentifier: "zhibo")
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none;
        self.view.addSubview(self.tableView)
    }
    func initUI(){
     let url = "http://116.211.167.106/api/live/aggregation?uid=133825214&interest=1"
        Alamofire.request(url, method: .get).responseJSON{
        response in
            switch response.result{
            case.success:
            var dict = NSDictionary.init()
            dict = response.result.value as! NSDictionary
            let arr :NSArray = dict["lives"] as! NSArray
            for dict2 in arr{
                let model = zhiboModel()
                model.setValuesForKeys((dict2 as! NSDictionary) as! [String : Any])
                let model2 = firstModel()
                let dict3 = (dict2 as! NSDictionary)["creator"]
                model2.setValuesForKeys((dict3 as! NSDictionary) as! [String : Any])
                self.dataArr.add(model)
                self.dataArr2.add(model2)
            }
            self.tableView.reloadData()
            case.failure(let error):
                print(error)
                
            }
    }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ZhiBoCell = tableView.dequeueReusableCell(withIdentifier: "zhibo", for: indexPath) as! ZhiBoCell
        let model2 = self.dataArr2[indexPath.row] as! firstModel
        let model = self.dataArr[indexPath.row] as! zhiboModel
        
        cell.showDataWithModel(firstModel: model2, zhiboModel: model, indexPath: indexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let zhibo = ZhiBoViewController()
        let model2 = self.dataArr2[indexPath.row]
        let model = self.dataArr[indexPath.row]
        zhibo.liveFirstModel = model2 as! firstModel
        zhibo.liveZhiBoModel = model as! zhiboModel
        tabar.view.isHidden = true
        self.navigationController?.pushViewController(zhibo, animated: true)
        
    }
    
    
    
    
}
