//
//  CollectionFootView.swift
//  12
//
//  Created by 王吉吉 on 2016/11/21.
//  Copyright © 2016年 王喆. All rights reserved.
//

import UIKit
import Alamofire
class CollectionFootView: UICollectionReusableView {
    var dataArr = NSArray()
    //乐人推荐回调
    typealias pushClsures = (_ id:String) ->Void
    var myClosures:pushClsures?
    //猎乐回调
    typealias lieyuePush = () ->Void
    var lieyueClouseres:lieyuePush?
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes){
        Alamofire.request(wawaUrl, method: .get).responseJSON {
            response in
            switch response.result{
            case.success:
            var dict = NSDictionary.init()
            dict = response.result.value as! NSDictionary
            self.dataArr = dict["musician"] as! NSArray
            
         //创建UI
            let sectionView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: screenBounds.width, height: 40))
            sectionView.backgroundColor = UIColor.init(red:0.98,green:0.99 ,blue:0.97 ,alpha:1.00)
            self.addSubview(sectionView)
            
            let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: screenBounds.width, height: 40))
            label.text = "乐人推荐"
            label.textAlignment = NSTextAlignment.center
            label.font = UIFont.systemFont(ofSize: 17)
            sectionView.addSubview(label)
            
            let otherButton = UIButton.init(frame: CGRect.init(x: screenBounds.width - 50, y: -5, width: 50, height: 50))
            otherButton.setImage(UIImage(named:"singershow_arrow_right_h"), for: UIControlState.normal)
            otherButton.addTarget(self, action:#selector(CollectionFootView.click), for: UIControlEvents.touchUpInside)
            sectionView.addSubview(otherButton)
            
            let view = UIView.init(frame: CGRect.init(x: 0, y: 50, width: screenBounds.width, height: 140))
            view.backgroundColor = UIColor.white
            self.addSubview(view)

            let dic1:NSDictionary = self.dataArr[0] as! NSDictionary
            let dic2:NSDictionary = self.dataArr[1] as! NSDictionary
            let dic3:NSDictionary = self.dataArr[2] as! NSDictionary
            

            //1  内存有问题  先下载在处理, 不会内存暴涨.
        /***********************************************************************/
            let imagev1 = UIImageView.init(frame: CGRect.init(x: 5, y: 0, width: screenBounds.width * 0.7, height: 140))
            let urlStr = dic1.object(forKey: "image")
            SDWebImageDownloader.shared().downloadImage(with: NSURL.init(string: urlStr as! String) as URL!, options: SDWebImageDownloaderOptions.lowPriority, progress: {(receivedSize:NSInteger,expectedSize:NSInteger) in
            }, completed: {(image,data,error,finished) in
             imagev1.image = self.scaleFromImage(image: image!, newSize: CGSize.init(width: 547, height: 365))
            })
            let blackImage = UIImageView.init(frame: CGRect.init(x: 5, y: 0, width: screenBounds.width * 0.7, height: 140))
            blackImage.backgroundColor = UIColor.black
            blackImage.alpha = 0.2
            view.addSubview(imagev1)
            imagev1.addSubview(blackImage)
            blackImage.isUserInteractionEnabled = true
            imagev1.isUserInteractionEnabled = true
            let tapGester = UITapGestureRecognizer.init(target: self, action: #selector(CollectionFootView.image1Click))
            blackImage.addGestureRecognizer(tapGester)
      /***********************************************************************/
            
            //  图片上Label
            let label1 = UILabel()
            label1.text = self.subText(str: dic1["title"] as! String)
            label1.frame = CGRect.init(x: 0, y: 60, width: screenBounds.width * 0.7, height: 18)
            label1.font = UIFont.boldSystemFont(ofSize: 18)
            label1.isHighlighted = true
            label1.textAlignment = NSTextAlignment.center
            label1.textColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 1)
            imagev1.addSubview(label1)
            let label2 = UILabel()
            let text = dic1["title"] as! String
            let index1 = text.index((text.startIndex), offsetBy: 3)
            label2.text = text.substring(from: index1)
            label2.textColor = UIColor.white
            label2.frame = CGRect.init(x: 0, y: 80, width: screenBounds.width * 0.7, height: 12)
            label2.font = UIFont.systemFont(ofSize: 12)
            label2.textAlignment = NSTextAlignment.center
            imagev1.addSubview(label2)
            
            //2
            let imagev2 = UIImageView.init(frame: CGRect.init(x: screenBounds.width * 0.7 + 10, y: 0, width: screenBounds.width * 0.3 - 15, height: 67.5))
            imagev2.sd_setImage(with: NSURL.init(string: dic2["image"] as! String) as URL?)
            let blackImage2 = UIImageView.init(frame: CGRect.init(x: screenBounds.width * 0.7 + 10, y: 0, width: screenBounds.width * 0.3 - 15, height: 67.5))
            blackImage2.backgroundColor = UIColor.black
            blackImage2.alpha = 0.2
            view.addSubview(imagev2)
            imagev2.addSubview(blackImage2)
            blackImage2.isUserInteractionEnabled = true
            
            
            let label3 = UILabel()
            label3.text = self.subText(str: dic2["title"] as! String)
            label3.frame = CGRect.init(x: 0, y: 25, width: screenBounds.width * 0.3 - 15, height: 20)
            label3.font = UIFont.systemFont(ofSize: 13)
            label3.textColor = UIColor.white
            label3.textAlignment = NSTextAlignment.center
            imagev2.addSubview(label3)
            
            //3
            let imagev3 = UIImageView.init(frame: CGRect.init(x: screenBounds.width * 0.7 + 10, y: 72.5, width: screenBounds.width * 0.3 - 15, height: 67.5))
            imagev3.sd_setImage(with: NSURL.init(string: dic3["image"] as! String) as URL?)
            let blackImage3 = UIImageView.init(frame: CGRect.init(x: screenBounds.width * 0.7 + 10, y: 67.5, width: screenBounds.width * 0.3 - 15, height: 67.5))
            blackImage3.backgroundColor = UIColor.black
            blackImage3.alpha = 0.2
            view.addSubview(imagev3)
            imagev3.addSubview(blackImage3)
            let tapGester3 = UITapGestureRecognizer.init(target: self, action:#selector(CollectionFootView.image3Click))
            imagev3.addGestureRecognizer(tapGester3)
            blackImage3.isUserInteractionEnabled = true
            imagev3.isUserInteractionEnabled = true
            
            let label4 = UILabel()
            label4.text = self.subText(str: dic3["title"] as! String)
            label4.frame = CGRect.init(x: 0, y: 25, width: screenBounds.width * 0.3 - 15, height: 20)
            label4.font = UIFont.systemFont(ofSize: 13)
            label4.textColor = UIColor.white
            label4.textAlignment = NSTextAlignment.center
            imagev3.addSubview(label4)
            
            //猎艳合集
            let sectionView2 = UIView.init(frame: CGRect.init(x: 0, y: 210, width: screenBounds.width, height: 40))
            sectionView2.backgroundColor = UIColor.init(red:0.98,green:0.99 ,blue:0.97 ,alpha:1.00)
            self.addSubview(sectionView2)
            
            
            let lab1 = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: screenBounds.width, height: 40))
            lab1.text = "猎乐合集"
            lab1.textAlignment = NSTextAlignment.center
            lab1.font = UIFont.systemFont(ofSize: 17)
            sectionView2.addSubview(lab1)
            
            let otherB1 = UIButton.init(frame: CGRect.init(x: screenBounds.width - 50, y: -5, width: 50, height: 50))
            otherB1.setImage(UIImage(named:"singershow_arrow_right_h"), for: UIControlState.normal)
            otherB1.addTarget(self, action: #selector(CollectionHeadView.otherClick), for: UIControlEvents.touchUpInside)
            sectionView2.addSubview(otherB1)
            
            let lieyanDict = dict["album"] as! NSDictionary
            
            let lieyanImageView = UIImageView()
            lieyanImageView.frame = CGRect.init(x: 5, y: 260, width: screenBounds.width - 10, height: 170)
            lieyanImageView.sd_setImage(with: NSURL.init(string: lieyanDict["mphoto"] as! String) as URL?)
            self.addSubview(lieyanImageView)
            
            lieyanImageView.isUserInteractionEnabled = true
            let tapGester2 = UITapGestureRecognizer.init(target: self, action:#selector(CollectionFootView.lieyanClick))
            lieyanImageView.addGestureRecognizer(tapGester2)
            
            
            let lieyanLabel1 = UILabel.init(frame: CGRect.init(x: 5, y: screenBounds.height - 40, width: 100, height: 13))
            lieyanLabel1.textColor = UIColor.white
            lieyanLabel1.font = UIFont.systemFont(ofSize: 11)
            lieyanLabel1.text = String(format:"VOL.%@",lieyanDict["mnum"] as! String)
            lieyanImageView.addSubview(lieyanLabel1)
            
            let lieyanLabel2 =  UILabel.init(frame: CGRect.init(x: 5, y: screenBounds.height - 20, width: 100, height: 20))
            lieyanLabel2.textColor = UIColor.white
            lieyanLabel2.font = UIFont.systemFont(ofSize: 18)
            lieyanLabel2.text = String(format:"%@",lieyanDict["mname"] as! String)
            lieyanImageView.addSubview(lieyanLabel2)
            case.failure(let error):
                print(error)
                
            }
    }
}
    func image1Click(){
    let dic4:NSDictionary = self.dataArr[0] as! NSDictionary
        if myClosures != nil{
          self.myClosures!(String(format:"%@",dic4["id"] as! String))
        }
    }
    func image2Click(){
        let dic4:NSDictionary = self.dataArr[1] as! NSDictionary
        if myClosures != nil{
            self.myClosures!(String(format:"%@",dic4["id"] as! String))
        }
    }
    func image3Click(){
        let dic4:NSDictionary = self.dataArr[2] as! NSDictionary
        if myClosures != nil{
            self.myClosures!(String(format:"%@",dic4["id"] as! String))
        }
    }
    func lieyanClick(){
        if lieyueClouseres != nil{
          self.lieyueClouseres!()
        }
    }
    func click(){
     
    }
    func subText(str:String) -> String{
        let text = str
        let index1 = text.index((text.startIndex), offsetBy: 2)
         return  text.substring(to: index1)
    }
    func scaleFromImage(image:UIImage,newSize:CGSize)->UIImage{
       let imageSize = image.size
        let width = imageSize.width
        let height = imageSize.height
        if (width <= newSize.width) && (height <= newSize.height){
         return image
        }
        if width == 0 || height == 0{
          return image
        }
        
        
        let widthFactor = newSize.width/width
        let heightFactor = newSize.height/height
        let scaleFator = widthFactor/heightFactor
        let scaledWidth = width * scaleFator
        let scaledHeight = height * heightFactor
        let targetSize = CGSize.init(width: scaledWidth, height: scaledHeight)
        _ = UIGraphicsBeginImageContext(targetSize)
        image.draw(in: CGRect.init(x: 0, y: 0, width: scaledWidth, height: scaledHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
        
    }
}
