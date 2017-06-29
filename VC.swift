//
//  VC.swift
//  12
//
//  Created by 王吉吉 on 2016/11/18.
//  Copyright © 2016年 王喆. All rights reserved.
//

import UIKit
class VC: UIViewController {
    var naviButtonView = UIView()
    var isButton = UIButton()
    let bottomView = UIScrollView()
    let midView = UIView()
    var leftView = UIView()
    var rightView = UIView()
    //左侧view
    var myView = MyViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.initNav()
       self.initTabBarView()
       self.creatSideView()
       self.pushClourse()
    }
    //push回调
    func pushClourse(){
        myView.myPushClouser = {(vc) in
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func creatSideView(){
        //最底层View
        bottomView.frame = CGRect.init(x: 0, y: 0, width: screenBounds.width, height: screenBounds.height)
        bottomView.contentSize = CGSize.init(width: screenBounds.width * 3, height: screenBounds.height - 114)
        bottomView.isPagingEnabled = true
       // bottomView.isScrollEnabled = false
        bottomView.contentOffset.x = screenBounds.width
        self.view.addSubview(bottomView)
        
        //中间
        midView.frame = CGRect.init(x: screenBounds.width, y: 0, width: screenBounds.width, height: screenBounds.height)
        bottomView.addSubview(midView)
        
        let b = self.getPages()
        addChildViewController(b)
        midView.addSubview(b.view)
        b.didMove(toParentViewController: self)
        //左侧
        leftView = UIView()
        leftView.frame = CGRect.init(x: 0, y: 0, width: screenBounds.width, height: screenBounds.height)
        bottomView.addSubview(leftView)
        leftView.addSubview(myView.view)
        
        //右侧
        rightView = UIView()
        rightView.frame = CGRect.init(x: screenBounds.width * 2, y: 0, width: screenBounds.width, height: screenBounds.height)
        rightView.backgroundColor = UIColor.blue
        bottomView.addSubview(rightView)
        
        let c = self.getRightPages()
        addChildViewController(c)
        rightView.addSubview(c.view)
        c.didMove(toParentViewController: self)
    }
    //右侧
    func getRightPages() -> WMPageController {
        
        let controllers = NSArray.init(objects: DingYueViewController.self,YIWenViewController.self,YouPingViewController.self,LvXingViewController.self,YingYongViewController.self)
        let titles = NSArray.init(objects: "订阅","艺文","有品","旅行","应用")
        let pageController = WMPageController.init(viewControllerClasses: controllers as! [AnyClass], andTheirTitles: titles as! [String])
        pageController?.otherGestureRecognizerSimultaneously = true
        pageController?.menuItemWidth = 50
        pageController?.menuHeight = 40
        // [UIColor colorWithRed:0.19f green:0.76f blue:0.49f alpha:1.00f];
        //pageController?.titleColorSelected = UIColor.init(red: 0.19, green: 0.76, blue: 0.49, alpha: 1)
        pageController?.titleColorNormal = UIColor.gray
        pageController?.titleColorSelected = UIColor.black
        return pageController!
        
    }
    
    
    func getPages() -> WMPageController {
        
        let controllers = NSArray.init(objects: ViewController.self,SecondViewController.self,ThreeViewController.self,FourViewController.self,MVViewController.self)
        let titles = NSArray.init(objects: "精选","电台","分类","直播","MV")
        let pageController = WMPageController.init(viewControllerClasses: controllers as! [AnyClass], andTheirTitles: titles as! [String])
        pageController?.otherGestureRecognizerSimultaneously = true
        pageController?.menuItemWidth = 50
        pageController?.menuHeight = 40
        // [UIColor colorWithRed:0.19f green:0.76f blue:0.49f alpha:1.00f];
        pageController?.titleColorSelected = UIColor.init(red: 0.19, green: 0.76, blue: 0.49, alpha: 1)
        return pageController!
        
    }
    func leftGestureClick(){
        print("左滑手势执行")
    }
    func initNav() {

        
        let leftGesture = UISwipeGestureRecognizer.init(target: self, action: #selector(VC.leftGestureClick))
        leftGesture.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(leftGesture)

        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent;
        naviButtonView.frame.size = CGSize.init(width: 220, height: 20)
        let MusicButton = UIButton.init(type: UIButtonType.custom)
        MusicButton.frame = CGRect.init(x: naviButtonView.frame.width/2 - 25, y: 0, width: 60, height: 20)
        MusicButton.setTitle("首页", for: UIControlState.normal)
        MusicButton.addTarget(self, action: #selector(naviClick(_:)), for: UIControlEvents.touchUpInside)
        naviButtonView.addSubview(MusicButton)
        
        let MyButton = UIButton.init(type: UIButtonType.custom)
        MyButton.frame = CGRect.init(x: 0, y: 0, width: 50, height: 20)
        MyButton.setTitle("我的", for: UIControlState.normal)
        MyButton.addTarget(self, action: #selector(naviClick(_:)), for: UIControlEvents.touchUpInside)
        naviButtonView.addSubview(MyButton)
        
        let FindButton = UIButton.init(type: UIButtonType.custom)
        FindButton.frame = CGRect.init(x: naviButtonView.frame.width - 50, y: 0, width: 50, height: 20)
        FindButton.setTitle("发现", for: UIControlState.normal)
        FindButton.addTarget(self, action: #selector(naviClick(_:)), for: UIControlEvents.touchUpInside)
        naviButtonView.addSubview(FindButton)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage(named:"concise_icon_more_normal"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(VC.leftButton))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named:"concise_icon_more_normal"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(VC.rightButton))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        self.navigationController?.navigationBar.barTintColor = UIColor.init(patternImage: UIImage(named:"link_info")!)
        self.navigationItem.titleView = naviButtonView
    }
    
    func leftButton(){
        
    }
    func rightButton(){
        
    }
    func initTabBarView(){
      let tabbarViewController = TabBarViewController.TabBar
       tabbarViewController.view.frame = CGRect.init(x: 0, y: screenBounds.height - 40, width: screenBounds.width, height: 44)
        tabbarViewController.view.isHidden = true
        UIApplication.shared.keyWindow?.addSubview(tabbarViewController.view)
       
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func naviClick(_ btn:UIButton){
        
        isButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        isButton = btn
        
        if btn.currentTitle == "我的"{
           bottomView.contentOffset.x = 0
           myView.readDB()
        }else if btn.currentTitle == "发现"{
            bottomView.contentOffset.x = screenBounds.width * 2
            
        }else{
            bottomView.contentOffset.x = screenBounds.width
            
        }
    }

   

}
