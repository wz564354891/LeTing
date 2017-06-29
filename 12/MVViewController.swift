//
//  MVViewController.swift
//  12
//
//  Created by 王吉吉 on 2016/11/25.
//  Copyright © 2016年 王喆. All rights reserved.
//

import UIKit
import Alamofire
let ustr = "http://www.buyao.tv/appapi/index.php?appkey=BYMUSICOFFVN0DtKGcebowgEPLtASJfBBn6iOTQ&ac=video&page=%d"
class MVViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var _tableView:UITableView?
    var _dataArr = NSMutableArray()
    var page:Int  = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.creatUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self._dataArr.removeAllObjects()
        self._tableView?.mj_header.beginRefreshing()
    }
    func initNet(page:Int){
        let url  = String(format:ustr,page)
        Alamofire.request(url, method: .get).responseJSON {
            response in
            switch response.result{
            case.success:
                var dict = NSDictionary.init()
                dict = response.result.value as! NSDictionary
                let arr = dict["by_item"] as! NSArray
                for dict2 in arr{
                    let model = firstModel()
                    model.setValuesForKeys(dict2 as! [String : Any])
                    self._dataArr.add(model)
                }
                self._tableView?.mj_header.endRefreshing()
                self._tableView?.mj_footer.endRefreshing()
                self._tableView?.reloadData()
               
            case.failure(let error):
                print(error)
               
            }
        }
    }
    func creatUI(){
       self._tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: screenBounds.width, height: screenBounds.height), style: UITableViewStyle.plain)
        self._tableView?.delegate = self
        self._tableView?.dataSource = self
        self._tableView?.rowHeight = 150
        self._tableView?.register(UINib.init(nibName: "MVCell", bundle: nil), forCellReuseIdentifier: "MV")
        self.view.addSubview(self._tableView!)
        //刷新
        self._tableView?.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(MVViewController.headRereshing))
        self._tableView?.mj_footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(MVViewController.footRereshing))
        
        
    }
    //下拉刷新
    func headRereshing(){
       page = 0
        self.initNet(page: page)
      
    }
    func footRereshing(){
        page += 1
        self.initNet(page: page)
    }
    
    //上拉加载
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       print(_dataArr.count)
         return _dataArr.count
        
        
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MVCell = tableView.dequeueReusableCell(withIdentifier: "MV", for: indexPath) as!MVCell
        
        let model:firstModel = self._dataArr[indexPath.row] as! firstModel
        cell .showDataWithModel(model: model, indexPath: indexPath as NSIndexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model:firstModel = self._dataArr[indexPath.row] as! firstModel
        let play = MVPLayController()
        play.model = model
        self.navigationController?.pushViewController(play, animated: true)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
