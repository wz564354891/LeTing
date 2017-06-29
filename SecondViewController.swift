//
//  SecondViewController.swift
//  12
//
//  Created by 王吉吉 on 2016/11/4.
//  Copyright © 2016年 王喆. All rights reserved.
//

import UIKit
import Alamofire


class SecondViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
     var dataArr = NSMutableArray()
     var _collection :UICollectionView?
     var tableHeaderView = MusicListHeadView()
     var trackIndex = "946"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initNet(inde: trackIndex)
    }
    
    func initNet(inde:String){
        // http://app.9nali.com/index/937?page_id=1&device=iPhone&version=1.1.5
        self.dataArr.removeAllObjects()
        let u =  "http://app.9nali.com/%@?page_id=1&device=iPhone&version=1.1.5"
        let ustr = String(format:u,inde)
        Alamofire.request(ustr, method: .get).responseJSON {
            response in
            switch response.result{
            case.success:
            var dict = NSDictionary.init()
            dict = response.result.value as! NSDictionary
            
            let arr1 = dict["list"] as AnyObject
            print(arr1.classForCoder)
            if dict["list"] != nil {
            let arr :NSArray = dict["list"] as! NSArray
            for dict2 in arr{
                let model = firstModel()
                model.setValuesForKeys((dict2 as! NSDictionary) as! [String : Any])
                self.dataArr.add(model)
                }
            self._collection?.reloadData()
            self.creatUI()
           
            }else{
                WZAlertView.showWithText(text: "暂无数据, 请继续刷新")
                }
            case.failure(let error):
                print(error)
                
            }
        }
    }
    
    func creatUI(){
        if _collection == nil{
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize.init(width: screenBounds.width / 2 - 10 , height: 200)
            layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5)
            self.automaticallyAdjustsScrollViewInsets = false
            _collection = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: screenBounds.width, height: screenBounds.height), collectionViewLayout: layout)
            _collection?.delegate = self
            _collection?.dataSource = self
            _collection?.backgroundColor = UIColor.white
            
            
            _collection?.register(UINib.init(nibName: "MusicListCell", bundle: nil), forCellWithReuseIdentifier: "collection")
            self.view.addSubview(_collection!)
            
            _collection?.register(MusicListHeadView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headView")
        }
        
       
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.init(width: screenBounds.width, height: 180)
        
    }
   
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        var view = tableHeaderView
        if kind == UICollectionElementKindSectionFooter{
                 }else{
            view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headView", for: indexPath as IndexPath) as! MusicListHeadView
            //闭包回调
            view.myClosures = {() in
                let max: UInt32 = 800
                let min: UInt32 = 700
                let ind:UInt32 =  arc4random_uniform(max - min) + min // 82
                self.trackIndex = "\(ind)"
                self.initNet(inde: self.trackIndex)
            }
            
        }
        return view
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: screenBounds.width / 2 - 10, height: 200)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
        
    }
    //1130
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:MusicListCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collection", for: indexPath) as! MusicListCell
        cell.backgroundColor = UIColor.white
        let model  = self.dataArr[indexPath.row] as! firstModel
        cell .showDataWithModel(model: model, indexPath: indexPath as NSIndexPath)
        return cell
    }
    func  collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                let model:firstModel = self.dataArr[indexPath.row] as! firstModel
                let detail = FirstDetailViewController()
                detail.uid = "\(model.uid)"
                detail.trackIndex = self.trackIndex
                self.navigationController?.pushViewController(detail, animated: true)
        
    }
 
}
