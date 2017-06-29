//
//  MVDownCell.swift
//  12
//
//  Created by 王吉吉 on 2016/12/20.
//  Copyright © 2016年 王喆. All rights reserved.
//

import UIKit

class MVDownCell: UITableViewCell {
    var url = ""
    var timer = Timer()
    var httpRequest = BreakPointHttpRequest()
    var speed = CGFloat()
    var loadedFileSize = NSInteger()
    var preLoadFileSize = NSInteger()
    
    @IBOutlet var TotalLabel: UILabel!
    @IBOutlet var FinshedLabel: UILabel!
    @IBOutlet var speedLabel: UILabel!
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var headImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func showDataWithModel(model:firstModel,indexPath:NSIndexPath){
       self.headImage.sd_setImage(with: NSURL.init(string: model.image) as URL!)
       self.titleLabel.text = model.title
       self.url = model.url
        self.startDownload()
    }
    func startDownload(){
        let str:NSString = self.url as NSString
        var scale = UserDefaults.standard.object(forKey: str.md5Hash())
        if scale != nil{
            self.progressView.progress = scale as! Float
        }
        self.httpRequest = BreakPointHttpRequest()
        timer = Timer.scheduledTimer(withTimeInterval: 1, block: {() in
            self.speed = CGFloat((self.loadedFileSize - self.preLoadFileSize)) / 1024
            self.preLoadFileSize = self.loadedFileSize
        }, repeats: true) as! Timer
        self.httpRequest.downloadData(withUrl: self.url,type:".mp4", progress: {(httpRequest) in
            self.loadedFileSize = NSInteger(Double((httpRequest?.loadedFileSize)!))
            let s:Double = (Double)(self.loadedFileSize) / (Double)((httpRequest?.totalFileSize)!)
            self.speedLabel.text = String(format:"%.2fkb/s",self.speed)
            self.TotalLabel.text = String(format:"%.2fMB/%.2fMB",(Double)(self.loadedFileSize) / 1024 / 1024,(Double)(self.httpRequest.totalFileSize)/1024/1024)
            if s * 100 == 100{
                //下载完成
                self.progressView.isHidden = true
                self.speedLabel.isHidden = true
                self.TotalLabel.isHidden = true
                self.FinshedLabel.isHidden = false
                self.FinshedLabel.text = "下载完成"
//                if self.myClosures != nil{
//                    self.myClosures!(self.url as NSString)
//                }
            }
            let str:NSString = self.url as NSString
            UserDefaults.standard.set(s, forKey:str.md5Hash())
            UserDefaults.standard.synchronize()
            self.progressView.progress = Float(s)
            if s >= 1.0{
                if self.timer .isValid{
                    self.timer.invalidate()
                }
            }
        })
        
    }
    func stopDownLoad(){
        if timer.isValid {
            timer.invalidate()
        }
        //停止下载
        httpRequest.stopDownload()
    }
}
