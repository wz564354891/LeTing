//
//  ViewController.swift
//  12
//
//  Created by 王吉吉 on 2016/11/3.
//  Copyright © 2016年 王喆. All rights reserved.
//
var wawaUrl = "http://wawa.fm:9090/wawa/api.php/index/fmfragment1"
var urlStr = "http://app.9nali.com/935?page_id=1&device=iPhone&version=1.1.5"
import UIKit
import Alamofire
class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    var dataArr:NSMutableArray = NSMutableArray()
    var _tableView:UITableView?
    var _collection:UICollectionView?
    var isButton = UIButton()
    var headImageArr:NSMutableArray = NSMutableArray()
    var tableHeaderView = CollectionHeadView()
    var tableFooderView = CollectionFootView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initNet()
        self.testSwitch()
        //监听订阅列表的push事件
        NotificationCenter.default.addObserver(self, selector: #selector(pushNotification(_:)), name: NSNotification.Name("pushNotification"), object: nil)
    }
    func testSwitch(){
        let button = UIButton()
        switch button.tag {
        case 1:
            break
        case 2:
            break
        case 3:
            break
        case 4:
            break
        case 1:
            break
        case 1:
            break
        case 1:
            break
        case 1:
            break
        case 1:
            break
        case 1:
            break
        default:
            break
        }
    }
    
    func initNet(){
            let ustr =  "http://app.9nali.com/935/common_tag/4/%E7%AC%91%E8%AF%9D%E6%AE%B5%E5%AD%90?page_id=1&device=iPhone&version=1.1.5"
        
            Alamofire.request(ustr, method: .get).responseJSON {
                response in
                switch response.result{
                case.success:
                    print(response)
                    print(response.result)
                var dict = NSDictionary.init()
                dict = response.result.value as! NSDictionary
                    if (dict.object(forKey: "ret") != nil){
                       let retNum = dict["ret"] as Any
                        if (retNum as AnyObject).intValue == 500{
                        self.creatAlertView()
                            return
                        }
                    }
                let arr :NSArray = dict["list"] as! NSArray
                 for dict2 in arr{
                  let model = firstModel()
                  model.setValuesForKeys((dict2 as! NSDictionary) as! [String : Any])
                 self.dataArr.add(model)
                }
                self._collection?.reloadData()
                self.creatUI()
                case.failure(let error):
                    print(error)
                    print("请求失败")
                    
                }
            }
           
        }
    
    func creatAlertView(){
      let alert = UIAlertController.init(title: "警告", message: "服务器开小差了", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction.init(title: "重试", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
            self.initNet()
        }))
        alert.addAction(UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel, handler: { (UIAlertAction) in
           print("取消")
        }))
        self.present(alert, animated: true, completion: nil)
    
    }
    func creatUI(){
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize.init(width: 113, height: 143)
        layout.sectionInset = UIEdgeInsetsMake(10, 5, 10, 5)
        self.automaticallyAdjustsScrollViewInsets = false
        _collection = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: screenBounds.width, height: screenBounds.height), collectionViewLayout: layout)
        _collection?.delegate = self
        _collection?.dataSource = self
        _collection?.backgroundColor = UIColor.white
        
        
        _collection?.register(UINib.init(nibName: "HotCell", bundle: nil), forCellWithReuseIdentifier: "collection")
        self.view.addSubview(_collection!)
        
        _collection?.register(CollectionHeadView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headView")
        
        _collection?.register(CollectionFootView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footView")
        
                
    }
   
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.init(width: screenBounds.width, height: 240)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.init(width: screenBounds.width, height: 500)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
       var view = tableHeaderView
    
       var view1 = tableFooderView
        if kind == UICollectionElementKindSectionFooter{
         view1 = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footView", for: indexPath as IndexPath) as! CollectionFootView
            view1.myClosures = {(id) in
                let web = le_wenDetailViewController()
                web.id = id
            self.navigationController?.pushViewController(web, animated: true)
          
            }
            view1.lieyueClouseres = {() in
                let lieyue = lieYueViewController()
                self.navigationController?.pushViewController(lieyue, animated: true)
            }
             return view1
            
        }else{
          view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headView", for: indexPath as IndexPath) as! CollectionHeadView
            
             return view
     }
    }
   
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:HotCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collection", for: indexPath) as! HotCell
        cell.backgroundColor = UIColor.white
        let model  = self.dataArr[indexPath.row] as! firstModel
        cell .showDataWithModel(model: model, indexPath: indexPath as NSIndexPath)
        return cell
    }
    func  collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model  = self.dataArr[indexPath.row] as! firstModel
        let detail = DetailViewController()
        detail.albuId = model.id
        detail.trackIndex = "935"
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
   //通知push事件
    func pushNotification(_ model:NSNotification){
    let model = model.object as! firstModel
    let detail = DetailViewController()
    detail.albuId = model.albumId
    detail.trackIndex = model.trackIndex
    self.navigationController?.pushViewController(detail, animated: true)
}

deinit {
    NotificationCenter.default.removeObserver(self)
}


}

