//
//  ThreeViewController.swift
//  12
//
//  Created by 王吉吉 on 2016/11/4.
//  Copyright © 2016年 王喆. All rights reserved.
//
//http://app.9nali.com/935/common_tag/4/%E7%AC%91%E8%AF%9D%E6%AE%B5%E5%AD%90?page_id=1&device=iPhone&version=1.1.5

import UIKit
import Alamofire
class ThreeViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var _collection:UICollectionView?
    var tableHeaderView = FMHeadView()
    var titleArr = NSMutableArray()
    var dataArr = NSMutableArray()
    var isView = UIView()
    var isButton = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initNet()
        self.creatLeftView()
        
    }
    //http://app.9nali.com/index/926
    let arr = [
        "http://app.9nali.com/935/common_tag/4/%E7%AC%91%E8%AF%9D%E6%AE%B5%E5%AD%90?page_id=1&device=iPhone&version=1.1.5"
        ,"http://app.9nali.com/935/common_tag/4/%E8%84%B1%E5%8F%A3%E7%A7%80?page_id=1&device=iPhone&version=1.1.5"
        ,"http://app.9nali.com/935/common_tag/4/%E5%86%B7%E7%AC%91%E8%AF%9D?page_id=1&device=iPhone&version=1.1.5"
        ,"http://app.9nali.com/935/common_tag/4/%E6%B6%A8%E5%A7%BF%E5%8A%BF?page_id=1&device=iPhone&version=1.1.5"
        ,"http://app.9nali.com/935/common_tag/4/%E8%81%8A%E7%94%B5%E5%BD%B1?page_id=1&device=iPhone&version=1.1.5"
        ,"http://app.9nali.com/935/common_tag/4/%E8%AE%BF%E8%B0%88%E7%A7%80?page_id=1&device=iPhone&version=1.1.5"
        ,"http://app.9nali.com/935/common_tag/4/%E6%96%B9%E8%A8%80%E7%A7%80?page_id=1&device=iPhone&version=1.1.5"
        ,"http://app.9nali.com/935/common_tag/4/%E7%A5%9E%E5%90%90%E6%A7%BD?page_id=1&device=iPhone&version=1.1.5"
        ,"http://app.9nali.com/935/common_tag/4/%E4%B8%87%E5%90%88%E9%A2%91%E9%81%93?page_id=1&device=iPhone&version=1.1.5"
        ]
    
    func initNet(){
        let queue:OperationQueue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        for i in 0..<9 {
        queue.addOperation({() in
         self.netReuqest(int: i)
            
        })
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
    func netReuqest(int:Int){
        let ustr =  arr[int]
        Alamofire.request(ustr, method: .get).responseJSON {
            response in
            switch response.result{
            case.success:
            let oneArr = NSMutableArray()
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
                oneArr.add(model)
            }
            
           self.dataArr.add(oneArr)
            if int == 8{
              self.creatUI()
            self._collection?.reloadData()
            }
            case.failure(let error):
                print(error)
                
            }
            
        }
    }
    func creatUI() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize.init(width: (screenBounds.width-120 - 20)/2, height: 143)
        layout.sectionInset = UIEdgeInsetsMake(10, 5, 10, 5)
        self.automaticallyAdjustsScrollViewInsets = false
        _collection = UICollectionView.init(frame: CGRect.init(x: 110, y: 0, width: screenBounds.width-120, height: screenBounds.height), collectionViewLayout: layout)
        _collection?.delegate = self
        _collection?.dataSource = self
        _collection?.backgroundColor = UIColor.white
        
        
        _collection?.register(UINib.init(nibName: "HotCell", bundle: nil), forCellWithReuseIdentifier: "collection")
        self.view.addSubview(_collection!)
        
        _collection?.register(FMHeadView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "FMHead")
        
    }
   
    func creatLeftView(){
        titleArr  = ["笑话段子","脱口秀","冷笑话","涨姿势","聊电影","访谈秀","方言秀","神吐槽","万和频道"]
        let  scrollview = UIScrollView()
        scrollview.frame = CGRect.init(x: 0, y: 0, width: 100, height: 430)
        scrollview.contentSize = CGSize.init(width: 100, height: 431)
        self.view.addSubview(scrollview)
        for i in 0..<50{
         let view = UIView()
            view.frame = CGRect.init(x: 0,  y: 8 * i + 60, width: 5, height: 1)
            if i == 0{
            view.backgroundColor = UIColor.init(red: 0.19, green: 0.76, blue: 0.49, alpha: 1)
            }
            //[UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
            view.backgroundColor = UIColor.init(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
             if i%5 == 0 {
                view.frame.size.width = 20
                view.tag = 50 + i
                isView = view
            }
            scrollview.addSubview(view)
           
            
        }
        
        for j in 0..<9{
            let button = UIButton()
            button.frame = CGRect.init(x: 20, y: 40 * j + 53, width: 80, height: 15)
            button.setTitle(titleArr[j] as? String, for: UIControlState.normal)
            button.setTitleColor( UIColor.black, for: UIControlState.normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            button.addTarget(self, action: #selector(leftButton(_:)), for: UIControlEvents.touchUpInside)
            if j == 0{
                button.setTitleColor(UIColor.init(red: 0.19, green: 0.76, blue: 0.49, alpha: 1), for: UIControlState.normal)
            }
            button.tag = 100+j
            isButton = button
            scrollview.addSubview(button)
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print( _collection?.contentOffset.y as Any)
        let y = (_collection?.contentOffset.y)! as CGFloat
        if y < 1318{
           self.changeButton(tag: 0)
        }else if y < 2873 {
           self.changeButton(tag: 1)
        }else if y < 4428 {
            self.changeButton(tag: 2)
        }else if y < 5983 {
            self.changeButton(tag: 3)
        }else if y < 7538 {
            self.changeButton(tag: 4)
        }else if y < 9093 {
            self.changeButton(tag: 5)
        }else if y < 10648 {
            self.changeButton(tag: 6)
        }else if y < 12203 {
            self.changeButton(tag: 7)
        }else if y < 13432 {
            self.changeButton(tag: 8)
        }
        
    }
    func changeButton(tag:Int){
        let btn = self.view.viewWithTag(tag + 100) as! UIButton
        self.isButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        btn.setTitleColor(UIColor.init(red: 0.19, green: 0.76, blue: 0.49, alpha: 1), for: UIControlState.normal)
        self.isButton = btn
        let tag = (tag * 5) + 50
        let view = self.view.viewWithTag(tag)
        self.isView.backgroundColor =  UIColor.init(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
        view?.backgroundColor = UIColor.init(red: 0.19, green: 0.76, blue: 0.49, alpha: 1)
        self.isView = (view)!
    }
    func leftButton(_ btn:UIButton){
        UIView.animate(withDuration: 1, animations: {() in
//            self.isButton.setTitleColor(UIColor.black, for: UIControlState.normal)
//            btn.setTitleColor(UIColor.init(red: 0.19, green: 0.76, blue: 0.49, alpha: 1), for: UIControlState.normal)
//            self.isButton = btn
//            let tag = ((btn.tag - 100) * 5) + 50
//            let view = self.view.viewWithTag(tag)
//            self.isView.backgroundColor = UIColor.gray
//            view?.backgroundColor = UIColor.init(red: 0.19, green: 0.76, blue: 0.49, alpha: 1)
//            self.isView = (view)!
//           // self._collection?.contentOffset.y = CGFloat(1330 * (btn.tag - 100))
            let indexPath = NSIndexPath.init(row: 0, section: btn.tag - 100)
            self._collection?.scrollToItem(at: indexPath as IndexPath, at: UICollectionViewScrollPosition.centeredVertically, animated: true)
            
        })
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.init(width: screenBounds.width, height: 15)
        
    }
   
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        var view = tableHeaderView
       
        if kind == UICollectionElementKindSectionFooter{
        
        }else{
            view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FMHead", for: indexPath as IndexPath) as! FMHeadView
            view.label.text =  titleArr[indexPath.section] as? String
        }
         return view
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.dataArr.count
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let arr = self.dataArr[section] as! NSMutableArray
        return arr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:HotCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collection", for: indexPath) as! HotCell
        cell.backgroundColor = UIColor.white
        let arr = self.dataArr[indexPath.section] as! NSMutableArray
        let model  = arr[indexPath.row] as! firstModel
        cell .showDataWithModel(model: model, indexPath: indexPath as NSIndexPath)
        return cell
    }
    func  collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let arr = self.dataArr[indexPath.section] as! NSMutableArray
        let model  = arr[indexPath.row] as! firstModel
        let detail = DetailViewController()
        detail.albuId = model.id
        detail.trackIndex = "935"
        self.navigationController?.pushViewController(detail, animated: true)
        
    }

}
