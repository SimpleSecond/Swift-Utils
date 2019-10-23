//
//  BaseTabVerticalButton.swift
//  BaseTabController
//
//  Created by wdy on 2019/10/23.
//  Copyright © 2019 wdy. All rights reserved.
//

import UIKit

class BTVerticalButton: UIButton {
    
    // Y轴方向，距中心的偏移量
    private let OFFSET_Y: CGFloat = 5.0
    
    // 重写子视图位置大小
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 图片居中
        var point = self.imageView?.center
        point!.x = self.frame.size.width / 2
        point!.y = self.frame.size.height / 2 - OFFSET_Y
        self.imageView?.center = point!
        
        // 文字居中
        var frame = self.titleLabel?.frame
        frame?.origin.x = 0
        frame?.origin.y = (self.imageView?.frame.maxY)!
        frame?.size.width = self.frame.size.width
        
        self.titleLabel?.frame = frame!
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.font = UIFont.systemFont(ofSize: 12)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
