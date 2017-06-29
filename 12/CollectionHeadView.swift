//
//  CollectionHeadView.swift
//  12
//
//  Created by 王吉吉 on 2016/11/21.
//  Copyright © 2016年 王喆. All rights reserved.
//

import UIKit
import Alamofire
class CollectionHeadView: UICollectionReusableView {
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes){
        let headImageArr = NSMutableArray()
        //头视图数据
        Alamofire.request(wawaUrl, method: .get).responseJSON {
            response in
            switch response.result{
            case.success:
            var dict = NSDictionary.init()
            dict = response.result.value as! NSDictionary
            let arr:NSArray = dict["ad"] as! NSArray
            for dict2 in arr {
                let model = firstModel()
                //model.setValuesForKeys(dict2 as! [String : Any])
                model.image = (dict2 as! NSDictionary).object(forKey: "image") as! String
                headImageArr.add(model.image)
            }
           
            //头视图图片数组
            // let imageArr = ["http://p4.music.126.net/NnxcNzWLHMs_ibmVZRfANQ==/3445869446541953.jpg","http://p4.music.126.net/xbAhnNKU7P5VkSMFhIyiVA==/3265549556581177.jpg","http://p3.music.126.net/gyTABngZG2adrbgEU7bluw==/3265549552949176.jpg","http://p4.music.126.net/_LYoUmaH4XRWiv94VsbfPQ==/3417282145422712.jpg","http://p3.music.126.net/ILPSZz723oUC0Jgz6WFqgg==/1408474407250516.jpg","http://p4.music.126.net/eZZk6tz-TI53KNC7jbysfg==/3420580698415397.jpg","http://p3.music.126.net/33UF4-9UsarHdVvcqExqGw==/2946691186766226.jpg"]
            
            self.backgroundColor = UIColor.white
            let HeadScrollview:WZScrollView=WZScrollView.init(frame: CGRect.init(x: 0, y: 0, width: screenBounds.width, height: 140), imageArray:headImageArr as Array)
            
            let threeButtonView = UIView.init(frame: CGRect.init(x: 0, y: 140, width: screenBounds.width, height: 60))
            threeButtonView.backgroundColor = UIColor.white
            self.addSubview(HeadScrollview)
            self.addSubview(threeButtonView)
            let wid:Int = (Int)(screenBounds.width / 3)
            let titleArr = ["私人FM","分类","推荐"]
            let imageArr = ["discover_icon_mv","discover_icon_recognizer","discover_icon_singers"]
            for i in 0 ..< 3{
                let button = UIButton.init(frame: CGRect.init(x: CGFloat(wid * i), y: 10, width: screenBounds.width / 3, height: 40))
                button.setImage(UIImage(named:imageArr[i]), for: UIControlState.normal)
                button.setTitle(titleArr[i], for: UIControlState.normal)
                button.setTitleColor(UIColor.black, for: UIControlState.normal)
                
                button.addTarget(self, action: Selector(("threeClick")), for: UIControlEvents.touchUpInside)
                button.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -20, bottom: 0, right: 0)
                button.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 0)
                threeButtonView.addSubview(button)
                
            }
           
        let sectionView = UIView.init(frame: CGRect.init(x: 0, y: 200, width: screenBounds.width, height: 40))
            sectionView.backgroundColor = UIColor.init(red:0.98,green:0.99 ,blue:0.97 ,alpha:1.00)
            self.addSubview(sectionView)
            
            let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: screenBounds.width, height: 40))
            label.text = "热门推荐"
            label.textAlignment = NSTextAlignment.center
            label.font = UIFont.systemFont(ofSize: 17)
            sectionView.addSubview(label)
            
            let otherButton = UIButton.init(frame: CGRect.init(x: screenBounds.width - 50, y: -5, width: 50, height: 50))
            otherButton.setImage(UIImage(named:"singershow_arrow_right_h"), for: UIControlState.normal)
            otherButton.addTarget(self, action: #selector(CollectionHeadView.otherClick), for: UIControlEvents.touchUpInside)
            sectionView.addSubview(otherButton)
            
            case.failure(let error):
                print(error)
                
            }
        }
        
        
    }
    func threeClick(){
    
    }
    
    func otherClick(){
    }
}




