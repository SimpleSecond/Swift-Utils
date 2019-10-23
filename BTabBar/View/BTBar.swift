//
//  BTBar.swift
//  BaseTabController
//
//  Created by wdy on 2019/10/23.
//  Copyright © 2019 wdy. All rights reserved.
//

import UIKit

class BTBar: UITabBar {
    
    // 设置子视图，大小固定
    let barSubview: BTBarSubview! = {
        let subview = BTBarSubview.init()
        subview.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 49)
        return subview
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.barSubview)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 将barSubview放置到前面
        //self.barSubview.layoutSubviews()
        self.bringSubviewToFront(self.barSubview)
    }
    
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.clipsToBounds || self.isHidden || self.alpha == 0 {
            return nil
        }
        
        var result: UIView! = super.hitTest(point, with: event)
        if let _ = result {
            return result
        }
        
        for subview in self.subviews {
            let subPoint = subview.convert(point, from: self)
            result = subview.hitTest(subPoint, with: event)
            if let _ = result {
                return result
            }
        }
        
        return nil
    }
    
}
