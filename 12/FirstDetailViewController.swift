//
//  FirstDetailViewController.swift
//  12
//
//  Created by 王吉吉 on 2016/11/10.
//  Copyright © 2016年 王喆. All rights reserved.
//

import UIKit
import Alamofire
//常用颜色
var oftenColor:UIColor = UIColor.init(red: 0.19, green: 0.76, blue: 0.49, alpha: 1)
var screenBounds:CGRect = UIScreen.main.bounds  //获取屏幕大小
class FirstDetailViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    //对外属性
//    var urlStr1 = "http://app.9nali.com/937/bozhus/%@?page_id=1&device=iPhone&version=1.1.5"
    var uid = ""
    var trackIndex  = ""//专辑下标哦
    var largeLogo = String()
    var imageView1:UIImageView?
    var personalSignature = ""
    //成员变量
    var _tableView:UITableView?
    var dataArr = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.creatUI()
        self.initNet()
        
        
    }
    func creatUI() {
        _tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width:screenBounds.width , height: screenBounds.height), style: UITableViewStyle.plain)
        _tableView?.delegate = self
        _tableView?.dataSource = self
        _tableView?.rowHeight = 50
        imageView1? = UIImageView()
        imageView1?.frame = CGRect.init(x: 0, y: 0, width: screenBounds.width, height: 300)
        _tableView?.tableHeaderView = self.imageView1
        _tableView?.register(UINib.init(nibName: "FirstDetailCell", bundle: nil), forCellReuseIdentifier: "Detail")
        self.view.addSubview(_tableView!)
        
    }
    func initNet() {
        let u = "http://app.9nali.com/%@/bozhus/%@?page_id=1&device=iPhone&version=1.1.5"
        let urlSt = String(format:u,self.trackIndex,self.uid)
        Alamofire.request(urlSt, method: .get).responseJSON {
            response in
            switch response.result{
            case.success:
            var dict = NSDictionary.init()
            dict = response.result.value as! NSDictionary
           
            var arr = NSArray()
            if dict.value(forKey: "list") != nil{
              arr = dict.value(forKey: "list") as! NSArray
            }
           
            
            for dict2 in arr{
                let model = firstModel()
                let dict5 = dict2 as! NSDictionary
                model.setValuesForKeys(dict5 as! [String : Any])
                self.navigationItem.title = dict5.object(forKey: "title") as! String?
                self.imageView1?.sd_setImage(with:NSURL.fileURL(withPath: dict5.object(forKey: "largeLogo") as! String), placeholderImage: UIImage(named:"me"))
//
                
                self.dataArr.add(model)
                
            }
           self._tableView?.reloadData()
            case.failure(let error):
                print(error)
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:FirstDetailCell = tableView.dequeueReusableCell(withIdentifier: "Detail", for: indexPath) as!FirstDetailCell
     
        let model:firstModel = self.dataArr[indexPath.row] as! firstModel
        cell .showDataWithModel(model: model, indexPath: indexPath as NSIndexPath,type:"")
        
    return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model:firstModel = self.dataArr[indexPath.row] as! firstModel
        let detail = DetailViewController()
        detail.albuId = model.albumId
        detail.trackIndex = self.trackIndex
        self.navigationController?.pushViewController(detail, animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
