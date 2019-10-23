//
//  ViewController.swift
//  BaseTabController
//
//  Created by wdy on 2019/10/23.
//  Copyright © 2019 wdy. All rights reserved.
//

import UIKit

class ViewController: UITabBarController {
    
    // 图片名称数组
    var imageList: [String]! = ["main_home", "main_type", "main_community", "main_cart", "main_user"]
    var selectImageList: [String]! = ["main_home_press", "main_type_press", "main_community_press", "main_cart_press", "main_user_press"]
    // 文字标题
    var titleList: [String]! = ["首页", "分类", "社区", "购物车", "用户"]
    // 中间图片名
    var centerIconName: String! = "menu_cyc"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("viewDidLoad")
        let ctrl1 = UIViewController.init()
        ctrl1.view.backgroundColor = UIColor.white
        let ctrl2 = UIViewController.init()
        ctrl2.view.backgroundColor = UIColor.green
        let ctrl3 = UIViewController.init()
        ctrl3.view.backgroundColor = UIColor.red
        let ctrl4 = UIViewController.init()
        ctrl4.view.backgroundColor = UIColor.blue
        let ctrl5 = UIViewController.init()
        ctrl5.view.backgroundColor = UIColor.brown
        
        // 设置子控制器
        self.viewControllers = [ctrl1,ctrl2,ctrl3,ctrl4,ctrl5]
        
        // 添加自定义TabBar
        let btBar = BTBar.init()
        btBar.barSubview.delegate = self
        self.setValue(btBar, forKey: "tabBar")
        
        // 设置背景图片
        //self.tabBar.backgroundImage = UIImage.init(named: "bg_tabbar")
        
    }
}

extension ViewController: BTBarSubviewDelegate {
    func btbSubItemSelected(index: Int) {
        // 这里切换子控制器
        self.selectedIndex = index
    }
    
    func btbSubCenterClick() {
        print("CenterClick")
    }
    
    func btbSubItemTitleNormalColor() -> UIColor {
        return UIColor.darkGray
    }
    
    func btbSubItemTitleSelectedColor() -> UIColor {
        return UIColor.red
    }
    
    func btbSubItemCount() -> Int {
        return 4
    }
    
    func btbSubItemTitle(index: Int) -> String {
        return self.titleList[index]
    }
    
    func btbSubItemNormalImage(index: Int) -> String {
        return self.imageList[index]
    }
    
    func btbSubItemSelectImage(index: Int) -> String {
        return self.selectImageList[index]
    }
    
    func btbContainCenterImage() -> Bool {
        return true
    }
    
    func btbCenterImage() -> String {
        return centerIconName
    }
    
    
}


