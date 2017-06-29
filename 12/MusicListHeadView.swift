//
//  MusicListHeadView.swift
//  12
//
//  Created by 王吉吉 on 2016/11/22.
//  Copyright © 2016年 王喆. All rights reserved.
//

import UIKit

class MusicListHeadView: UICollectionReusableView {
  typealias sendClsures = () ->Void
   var myClosures:sendClsures?
    var imageV = UIImageView()
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes){
     let imgeaView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: screenBounds.width, height: 150))
        let imageArr = ["http://p4.music.126.net/NnxcNzWLHMs_ibmVZRfANQ==/3445869446541953.jpg","http://p4.music.126.net/xbAhnNKU7P5VkSMFhIyiVA==/3265549556581177.jpg","http://p3.music.126.net/gyTABngZG2adrbgEU7bluw==/3265549552949176.jpg","http://p4.music.126.net/_LYoUmaH4XRWiv94VsbfPQ==/3417282145422712.jpg","http://p3.music.126.net/ILPSZz723oUC0Jgz6WFqgg==/1408474407250516.jpg","http://p4.music.126.net/eZZk6tz-TI53KNC7jbysfg==/3420580698415397.jpg","http://p3.music.126.net/33UF4-9UsarHdVvcqExqGw==/2946691186766226.jpg"]
        let arcdom = Int(arc4random()%7)
        let url = NSURL.init(string: imageArr[arcdom as Int]) as URL?
        imgeaView.sd_setImage(with: url)
        self.addSubview(imgeaView)
      
        let sectionView = UIView.init(frame: CGRect.init(x: 0, y: 150, width: screenBounds.width, height: 40))
        sectionView.backgroundColor = UIColor.init(red:0.98,green:0.99 ,blue:0.97 ,alpha:1.00)
        self.addSubview(sectionView)
        
        let label = UILabel.init(frame: CGRect.init(x: 10, y: 0, width: screenBounds.width, height: 40))
        label.text = "全部歌单"
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont.systemFont(ofSize: 17)
        sectionView.addSubview(label)
        
        let otherButton = UIButton.init(frame: CGRect.init(x: screenBounds.width - 80, y: -5, width: 50, height: 50))
        //otherButton.setImage(UIImage(named:"singershow_arrow_right_h"), for: UIControlState.normal)
        otherButton.setTitle("换一批", for: UIControlState.normal)
        otherButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        otherButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        otherButton.addTarget(self, action: #selector(MusicListHeadView.otherClick), for: UIControlEvents.touchUpInside)
        sectionView.addSubview(otherButton)
        
        
        imageV = UIImageView()
        imageV.frame = CGRect.init(x: screenBounds.width - 35, y: 5, width: 30, height: 30)
        imageV.image = UIImage(named:"change")
        sectionView.addSubview(imageV)
        
        
        
    
    }
   
    func otherClick(){
        if (self.myClosures != nil){
            self.myClosures!()
        }
       let animation = CABasicAnimation.init(keyPath: "transform.rotation.z")
       animation.toValue = NSNumber.init(value: (2 * -M_PI))
        animation.duration = 0.5
        animation.repeatCount = 1
        animation.isRemovedOnCompletion = false
        imageV.layer.add(animation, forKey: "transform.rotation.z")
        
    }
    
}
