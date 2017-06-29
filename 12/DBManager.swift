//
//  DBManager.swift
//  
//
//  Created by 王吉吉 on 2016/12/5.
//
//''


import UIKit
var Favorite = "favorites"
var Browses = "browese"
class DBManager: NSObject {
  static let shareInstance = DBManager()
    //创建和打开一个数据库6
    //如果有就直接打开,没有创建一个打开
    lazy var db : FMDatabase = {
        let path:String = self.getFilefullPathWithFileName(fileName: "/app.db")!
     let db = FMDatabase.init(path: path)
        return db!
    }()
    override init(){
      super.init()
        if db.open(){
         print("打开数据库成功")
         self.creatTable()
        }
    }
    func creatTable(){
        
    let albumTable = "create table if not exists album(serial integer Primary Key Autoincrement,title Varchar(1024),appId INTEGER,count INTEGER,image Varchar(1024),trackIndex Varchar(1024),recordType Varchar(1024))"
    let DownloadTable = "create table if not exists Download(serial integer Primary Key Autoincrement,title Varchar(1024),url Varchar(1024),image Varchar(1024),trackId INTEGER,nickName Varchar(1024))"
    let broweseTable = "create table if not exists browese(serial integer Primary Key Autoincrement,title Varchar(1024),image Varchar(1024),playtimes INTEGER,duration INTEGER,mp3size_64 INTEGER,updatedAt BIGINT,trackId INTEGER,nickname Varchar(1024),bigImage Varchar(1024),playUrl64 Varchar(1024),playUrl32 Varchar(1024))"
    let MVDownloadTable = "create table if not exists MVDownload(serial integer Primary Key Autoincrement,title Varchar(1024),image Varchar(1024),url Varchar(1024),id Varchar(1024))"
    let loveTable = "create table if not exists love(serial integer Primary Key Autoincrement,title Varchar(1024),image Varchar(1024),playtimes INTEGER,duration INTEGER,mp3size_64 INTEGER,updatedAt BIGINT,trackId INTEGER,nickname Varchar(1024),bigImage Varchar(1024),playUrl64 Varchar(1024),playUrl32 Varchar(1024))"
        
        
        let isAlbumSuccees = db.executeUpdate(albumTable, withArgumentsIn: nil)
        let isDownLoadSuccess = db.executeUpdate(DownloadTable, withArgumentsIn: nil)
        let isBorweseSuccess = db.executeUpdate(broweseTable, withArgumentsIn: nil)
        let isMVDownloadSuccess = db.executeUpdate(MVDownloadTable, withArgumentsIn: nil)
        let isLoveSuccess = db.executeUpdate(loveTable, withArgumentsIn: nil)
        if isAlbumSuccees{
          print("专辑表格创建成功")
        }else{
            print(String(format:"专辑表格创建失败%@",db.lastError() as CVarArg))
        }
        if isDownLoadSuccess{
            print("下载表格创建成功")
        }else{
            print(String(format:"下载表格创建失败%@",db.lastError() as CVarArg))
        }
        if isBorweseSuccess{
            print("浏览表格创建成功")
        }else{
            print(String(format:"浏览表格创建失败%@",db.lastError() as CVarArg))
        }
        if isMVDownloadSuccess{
            print("浏览表格创建成功")
        }else{
            print(String(format:"浏览表格创建失败%@",db.lastError() as CVarArg))
        }
        if isLoveSuccess{
             print("喜欢表格创建成功")
            
        }else{
          print(String(format:"喜欢表格创建失败%@",db.lastError() as CVarArg))
        }
        
    }
    //插入专辑数据
    func insertAlbumModel(model:AnyObject,type:String){
        let albumModel:firstModel = model as! firstModel
        let isExist = self.isExistAppForAppId(albumId: String(format:"%@",albumModel.albumId),type:type)
        if isExist{
          return
        }
        let sql = "insert into album(title,appId,count,image,trackIndex,recordType) values (?,?,?,?,?,?)"
        let isSuccess = db.executeUpdate(sql, withArgumentsIn: [albumModel.title,"\(albumModel.albumId)","\(albumModel.tracks)",albumModel.coverSmall,albumModel.trackIndex,type])
        if !isSuccess{
            print(String(format:"插入专辑数据错误%@",db.lastError() as CVarArg))
        }
      
    }
    //插入下载数据
    func insertDownLoad(model:AnyObject){
        let downLoadModel = model as! firstModel
        let isExist = self.isExistDownLoadForTrackId(trackId: String(format:"%@",downLoadModel.trackId))
        if isExist{
          return
        }
            let sql = "insert into Download(title,url,image,trackId,nickName) values (?,?,?,?,?)"
            let isSuccess = db.executeUpdate(sql, withArgumentsIn: [downLoadModel.title,downLoadModel.playUrl64,downLoadModel.coverLarge,"\(downLoadModel.trackId)",downLoadModel.nickname])
            if !isSuccess{
                print(String(format:"插入下载数据错误%@",db.lastError() as CVarArg))
        }
        
        
    }
    //插入浏览数据
    func insertBrowese(model:AnyObject){
     let BroweseModel = model as! firstModel
        let isExist = self.isExistBroweseForTrackId(trackId: String(format:"%@",BroweseModel.trackId))
        if isExist{
         return
        }
        let sql = "insert into browese(title,image,playtimes,duration,mp3size_64,updatedAt,trackId,nickname,bigImage,playUrl64,playUrl32) values (?,?,?,?,?,?,?,?,?,?,?)"
        let isSuccess = db.executeUpdate(sql, withArgumentsIn: [BroweseModel.title,BroweseModel.coverSmall,"\(BroweseModel.playtimes)","\(BroweseModel.duration)","\(BroweseModel.mp3size_64)","\(BroweseModel.updatedAt)","\(BroweseModel.trackId)",BroweseModel.nickname,BroweseModel.coverLarge,BroweseModel.playUrl64,BroweseModel.playUrl32])
        if !isSuccess{
         print(String(format:"插入浏览数据错误%@",db.lastError() as CVarArg))
        }
    }
    //插入喜欢数据
    func insertLove(model:AnyObject){
        let loveModel = model as! firstModel
       let isExist = self.isExistLoveForTrackId(trackId: String(format:"%@",loveModel.trackId))
        if isExist{
        return
        }
        let sql = "insert into love(title,image,playtimes,duration,mp3size_64,updatedAt,trackId,nickname,bigImage,playUrl64,playUrl32) values (?,?,?,?,?,?,?,?,?,?,?)"
        let isSuccess = db.executeUpdate(sql, withArgumentsIn: [loveModel.title,loveModel.coverSmall,"\(loveModel.playtimes)","\(loveModel.duration)","\(loveModel.mp3size_64)","\(loveModel.updatedAt)","\(loveModel.trackId)",loveModel.nickname,loveModel.coverLarge,loveModel.playUrl64,loveModel.playUrl32])
        if !isSuccess{
          print(String(format:"插入喜欢数据错误%@",db.lastError() as CVarArg))
        }
    }
    //插入MV下载数据
    func insertMVDownload(model:AnyObject){
        let MVDownloadModel = model as! firstModel
        let isExist = self.isExistMVDownloadForId(id:String(format:"%@",MVDownloadModel.id))
        if isExist{
         return
        }
        let sql = "insert into MVDownload(title,image,url,id) values (?,?,?,?)"
        let isSuccess = db.executeUpdate(sql, withArgumentsIn: [MVDownloadModel.title,MVDownloadModel.image,MVDownloadModel.url,MVDownloadModel.id])
        if !isSuccess{
          print(String(format:"插入MV下载数据错误%@",db.lastError() as CVarArg))
        }
        
    }
    
    //查询专辑数据
    func readAlbumModelsWithType(type:String)->NSMutableArray{
     let sql = "select *from album where recordType = ?"
        let rs:FMResultSet = db.executeQuery(sql, withArgumentsIn: [type])
        let arr = NSMutableArray()
        while rs.next() {
            let model = firstModel()
            model.title = (rs.string(forColumn: "title"))!
            model.albumId = rs.int(forColumn: "appId") as NSNumber
            model.tracks = rs.int(forColumn: "count") as NSNumber
            model.coverSmall = (rs.string(forColumn: "image"))!
            model.trackIndex = rs.string(forColumn: "trackIndex")
            arr.add(model)
           
            print("专辑数据读取成功")
        }
        return arr
    }
    //查询下载数据
    func readDownloadModels()->NSMutableArray{
     let sql = "select title,url,image,trackId,nickName from Download"
        let rs:FMResultSet = db.executeQuery(sql, withArgumentsIn: nil)
        let arr = NSMutableArray()
        while rs.next() {
            let model = firstModel()
            model.title = rs.string(forColumn: "title")
            model.playUrl64 = rs.string(forColumn: "url")
            model.coverLarge = rs.string(forColumn: "image")
            model.trackId = rs.int(forColumn: "trackId") as NSNumber
            model.nickname = rs.string(forColumn: "nickName")
            arr.add(model)
            print("下载数据读取成功")
        }
        return arr
    }
    //查询浏览数据
    func readBroweseModels()->NSMutableArray{
     let sql = "select title,image,playtimes,duration,mp3size_64,updatedAt,trackId,nickname,bigImage,playUrl64,playUrl32 from browese"
        let rs:FMResultSet = db.executeQuery(sql, withArgumentsIn: nil)
        let arr = NSMutableArray()
        while rs.next() {
            let model = firstModel()
            model.title = rs.string(forColumn: "title")
            model.coverSmall = rs.string(forColumn: "image")
            model.playtimes = rs.int(forColumn: "playtimes") as NSNumber
            model.duration = rs.int(forColumn: "duration") as NSNumber
            model.mp3size_64 = rs.int(forColumn: "mp3size_64") as NSNumber
            model.updatedAt = rs.unsignedLongLongInt(forColumn: "updatedAt") as NSNumber
            model.trackId = rs.int(forColumn: "trackId") as NSNumber
            model.nickname = rs.string(forColumn: "nickname")
            model.coverLarge = rs.string(forColumn: "bigImage")
            model.playUrl64 = rs.string(forColumn: "playUrl64")
            model.playUrl32 = rs.string(forColumn: "playUrl32")
            arr.add(model)
            print("浏览数据读取数据成功")
        }
        return arr
    }
    //查询喜欢数据
    func readLoveModels()->NSMutableArray{
        let sql = "select title,image,playtimes,duration,mp3size_64,updatedAt,trackId,nickname,bigImage,playUrl64,playUrl32 from love"
        let rs:FMResultSet = db.executeQuery(sql, withArgumentsIn: nil)
        let arr = NSMutableArray()
        while rs.next() {
            let model = firstModel()
            model.title = rs.string(forColumn: "title")
            model.coverSmall = rs.string(forColumn: "image")
            model.playtimes = rs.int(forColumn: "playtimes") as NSNumber
            model.duration = rs.int(forColumn: "duration") as NSNumber
            model.mp3size_64 = rs.int(forColumn: "mp3size_64") as NSNumber
            model.updatedAt = rs.unsignedLongLongInt(forColumn: "updatedAt") as NSNumber
            model.trackId = rs.int(forColumn: "trackId") as NSNumber
            model.nickname = rs.string(forColumn: "nickname")
            model.coverLarge = rs.string(forColumn: "bigImage")
            model.playUrl64 = rs.string(forColumn: "playUrl64")
            model.playUrl32 = rs.string(forColumn: "playUrl32")
            arr.add(model)
            print("浏览数据读取数据成功")
        }
        return arr
    }
    //查询MV下载数据
    func readMVDownloadModels()->NSMutableArray{
     let sql = "select title,image,url,id from MVDownload"
        let rs:FMResultSet = db.executeQuery(sql, withArgumentsIn: nil)
        let arr = NSMutableArray()
        while rs.next() {
            let model = firstModel()
            model.title = rs.string(forColumn: "title")
            model.image = rs.string(forColumn: "image")
            model.url = rs.string(forColumn: "url")
            model.id = rs.int(forColumn: "id") as NSNumber
            arr.add(model)
        }
        return arr
    }
    //删除专辑数据
    func deleteAlbumModelForAppId(appId:String,type:String){
     let sql = "delete from album where appId = ? and recordType = ?"
        let isSuccess = db.executeUpdate(sql, withArgumentsIn: [appId,type])
        if !isSuccess{
            print(String(format:"删除专辑数据错误%@",db.lastError() as CVarArg))
        }
    }
    //删除专辑全部数据
    func deleteAllAlbum(){
       let sql = "delete from album"
        let isSuccess = db.executeUpdate(sql, withArgumentsIn: nil)
        if !isSuccess{
            print(String(format:"删除全部专辑数据错误%@",db.lastError() as CVarArg))
        }
    }
    //删除下载数据
    func deleteDownLoadModelForTitle(trackId:String){
        let sql = "delete from Download where trackId = ?"
        let isSuccess = db.executeUpdate(sql, withArgumentsIn: [trackId])
        if !isSuccess{
            print(String(format:"删除下载数据错误%@",db.lastError() as CVarArg))
        }
    }
    //删除全部下载数据
    func deleteAllDownLoad(){
        let sql = "delete from Download"
        let isSuccess = db.executeUpdate(sql, withArgumentsIn: nil)
        if !isSuccess{
            print(String(format:"删除全部下载数据错误%@",db.lastError() as CVarArg))
        }
    }
    //删除浏览数据
    func deleteBroweseForTrackId(trackId:String){
      let sql = "delete from browese where trackId = ?"
      let isSuccess = db.executeUpdate(sql, withArgumentsIn: [trackId])
        if !isSuccess{
         print(String(format:"删除浏览数据错误%@",db.lastError() as CVarArg))
         }
    }
    //删除全部浏览数据
    func deleteAllBrowese(){
        let sql = "delete from browese"
        let isSuccess = db.executeUpdate(sql, withArgumentsIn: nil)
        if !isSuccess{
            print(String(format:"删除全部浏览数据错误%@",db.lastError() as CVarArg))
        }
    }
    //删除喜欢数据
    func deleteLoveForTrackId(trackId:String){
        let sql = "delete from love where trackId = ?"
        let isSuccess = db.executeUpdate(sql, withArgumentsIn: [trackId])
        if !isSuccess{
            print(String(format:"删除喜欢数据错误%@",db.lastError() as CVarArg))
        }
    }
    //删除全部喜欢数据
    func deleteAllLove(){
        let sql = "delete from love"
        let isSuccess = db.executeUpdate(sql, withArgumentsIn: nil)
        if !isSuccess{
            print(String(format:"删除全部喜欢数据错误%@",db.lastError() as CVarArg))
        }
    }
    //检测专辑是否存在
    func isExistAppForAppId(albumId:String,type:String)->Bool{
      let sql = "select * from album where appId = ? and recordType = ?"
        let rs:FMResultSet = db.executeQuery(sql, withArgumentsIn:[albumId,type])
        if rs.next(){
          return true
        }else{
         return false
        }
    }
    
    
    //检测下载是否存在
    func isExistDownLoadForTrackId(trackId:String)->Bool{
        let sql = "select * from Download where trackId = ?"
        let rs:FMResultSet = db.executeQuery(sql, withArgumentsIn: [trackId])
        if rs.next(){
          return true
        }else{
          return false
        }
    }
    //检测浏览是否存在
    func isExistBroweseForTrackId(trackId:String)->Bool{
        let sql = "select * from browese where trackId = ?"
        let rs:FMResultSet = db.executeQuery(sql, withArgumentsIn: [trackId])
        if rs.next(){
            return true
        }else{
            return false
        }
    }
    //检测喜欢是否存在
    func isExistLoveForTrackId(trackId:String)->Bool{
        let sql = "select * from love where trackId = ?"
        let rs:FMResultSet = db.executeQuery(sql, withArgumentsIn: [trackId])
        if rs.next(){
          return true
        }else{
          return false
        }
    }
    //检测MV下载是否存在
    func isExistMVDownloadForId(id:String)->Bool{
        let sql = "select * from MVDownload where id = ?"
        let rs:FMResultSet = db.executeQuery(sql, withArgumentsIn: [id])
        if rs.next(){
            return true
        }else{
            return false
        }
    }
    
    
    
    func getFilefullPathWithFileName(fileName:String)->String?{
      let documentsFolder = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
     // let docPath = documentsFolder.appending("/Documents")
        print(documentsFolder)
        let fm:FileManager = FileManager.default
        if fm .fileExists(atPath: documentsFolder){
          return documentsFolder.appending(fileName)
        }else{
           print("Documents")
            return nil
        }
    }
    
    
}
