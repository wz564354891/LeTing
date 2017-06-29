//
//  DetailCell.swift
//  12
//
//  Created by 王吉吉 on 2016/11/14.
//  Copyright © 2016年 王喆. All rights reserved.
//

import UIKit

class DetailCell: UITableViewCell {
    typealias downClourse = (_ downModel:firstModel) ->Void
    var myDownClourse:downClourse?
    var model = firstModel()
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var downClick: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var playtimesLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()

    
    
    }
    func showDataWithModel(model:firstModel,indexPath:NSIndexPath){
        self.model = model
     self.titleLabel.text = model.title
        self.titleLabel.numberOfLines = 0
        self.playtimesLabel.text = "\(model.playtimes)"
        self.imageView1?.sd_setImage(with: NSURL.init(string: model.coverSmall) as URL?, placeholderImage: UIImage(named:"me"))
        let num = model.duration.doubleValue as Double
        let min:Int = Int(num/60)
        let s:Int = Int(num) - Int(min*60)
        
        self.durationLabel.text = String(format:"%02d : %02d",min,s)
        let a  = model.mp3size_64.doubleValue as Double
        let b = a/1024/1024
        self.sizeLabel.text = String(format: "%0.1fM",b)
        
        let date1 = "\(model.updatedAt)"
        let index = date1.index(date1.startIndex, offsetBy: 10)
      //  let index = date1.index(before: 10)
        let newDate:NSString = date1.substring(to: index) as NSString
        let t:Double = newDate.doubleValue
        let date = NSDate.init(timeIntervalSince1970: t)
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
       
        self.dateLabel.text = String(format: "%@",df.string(from: date as Date))
        
        
        
        
        
        
    }
    
    
    @IBAction func downClick(_ sender: Any) {
        if self.myDownClourse != nil{
           self.myDownClourse!(self.model)
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    
    }
    
}
