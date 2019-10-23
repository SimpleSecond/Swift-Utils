//
//  BaseTabBarSubview.swift
//  BaseTabController
//
//  Created by wdy on 2019/10/23.
//  Copyright © 2019 wdy. All rights reserved.
//

import UIKit


// MARK: - 代理协议
protocol BTBarSubviewDelegate {
    
    // 点击选中第几个Item
    func btbSubItemSelected(index: Int) -> Void
    // 点击中间的图片
    func btbSubCenterClick() -> Void
    
    // item标题的默认颜色
    func btbSubItemTitleNormalColor() -> UIColor
    // item标题的选中颜色
    func btbSubItemTitleSelectedColor() -> UIColor
    
    // item的数量
    func btbSubItemCount() -> Int
    // item的标题
    func btbSubItemTitle(index: Int) -> String
    // item默认图片
    func btbSubItemNormalImage(index: Int) -> String
    // item选中图片
    func btbSubItemSelectImage(index: Int) -> String
    
    // 判断是否包含中间图片
    func btbContainCenterImage() -> Bool
    // 中间图片
    func btbCenterImage() -> String
}


// MARK: - 视图
class BTBarSubview: UIView {
    
    // 事件代理
    var delegate: BTBarSubviewDelegate?
    
    // 私有：按钮数组
    private var itemBtns: [BTVerticalButton]!
    private var itemWidth: CGFloat! // 按钮宽度
    private var itemCount: Int!     // 按钮数量
    
    // 私有：文字颜色
    private var selectedColor: UIColor!
    private var normalColor: UIColor!
    
    // 私有：选中按钮索引
    private var selectedIndex: Int! = 0
    
    // 私有：中间是否含有图片按钮(默认没有)
    private var containCenterImage: Bool = false
    private let CenterImageWidth: CGFloat! = 80.0
    private var centerImageView: UIImageView!
    
    override var frame: CGRect {
        didSet {
            if self.frame != CGRect.zero {
                //self.loadSubviewFrame()
            }
        }
    }
    
    
    // 加载显示子视图
    override func layoutSubviews() {
        super.layoutSubviews()
        
        print("BTBarSubview")
        
        // 是否包含中间的图片
        self.containCenterImage = (self.delegate?.btbContainCenterImage())!
        // 获取Item的数量
        self.itemCount = self.delegate?.btbSubItemCount()
        
        // 获取文字默认颜色
        self.normalColor = self.delegate?.btbSubItemTitleNormalColor()
        // 获取文字选中颜色
        self.selectedColor = self.delegate?.btbSubItemTitleSelectedColor()
        
        if self.itemBtns == nil || self.itemBtns.count != self.itemCount {
            self.itemBtns = [BTVerticalButton].init(repeating: BTVerticalButton.init(), count: self.itemCount)
            
            for i in 0..<self.itemCount {
                let itemBtn = self.createItemButton(index: i)
                self.addSubview(itemBtn)
                self.itemBtns[i] = itemBtn
            }
        }
        
        if self.containCenterImage {
            self.centerImageView = UIImageView.init()
            self.centerImageView.image = UIImage.init(named: (self.delegate?.btbCenterImage())!)
            self.centerImageView.isUserInteractionEnabled = true
            self.centerImageView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(centerTapAction)))
            self.addSubview(self.centerImageView)
        }
        
        // 设置大小
        self.loadSubviewFrame()
        
        // 默认选中0
        self.itemBtns[selectedIndex].isSelected = true
        self.delegate?.btbSubItemSelected(index: selectedIndex)
    }
    
    // MARK: 设置子视图大小
    private func loadSubviewFrame() -> Void {
        let halfIndex = self.itemCount / 2
        
        if self.containCenterImage {
            self.centerImageView.frame = CGRect.init(x: 0, y: 0, width: CenterImageWidth, height: CenterImageWidth)
            self.centerImageView.center = CGPoint.init(x: self.frame.width/2, y: 0)
        }
        
        // 计算item宽度
        self.calculateItemWidth()
        
        // item大小设置
        if let _ = self.itemWidth {
            for i in 0..<self.itemCount {
                let itemBtn = self.itemBtns[i]
                itemBtn.frame = CGRect.init(x: 0, y: 0, width: self.itemWidth, height: self.frame.height)

                if self.containCenterImage && i >= halfIndex {
                    itemBtn.frame.origin = CGPoint.init(x: self.itemWidth * CGFloat(i) + CenterImageWidth, y: 0)
                } else {
                    itemBtn.frame.origin = CGPoint.init(x: self.itemWidth * CGFloat(i), y: 0)
                }
            }
        }
    }
    
    // MARK: 计算按钮的宽度
    private func calculateItemWidth() -> Void {
        var width = self.frame.width
        
        if self.containCenterImage {
            width = width - CenterImageWidth
        }
        
        if self.itemCount > 0 {
            self.itemWidth = width / CGFloat(self.itemCount)
        }
    }
    
    // MARK: 创建item按钮
    func createItemButton(index: Int) -> BTVerticalButton {
        let itemBtn = BTVerticalButton.init(type: .custom)
        itemBtn.setTitleColor(self.normalColor, for: .normal)
        itemBtn.setTitleColor(self.selectedColor, for: .selected)
        itemBtn.isSelected = false
        itemBtn.tag = index
        
        // 标题
        let itemTitle = self.delegate?.btbSubItemTitle(index: index)
        itemBtn.setTitle(itemTitle, for: .normal)
        // 图片
        let iconSelected = self.delegate?.btbSubItemSelectImage(index: index)
        let icon = self.delegate?.btbSubItemNormalImage(index: index)
        itemBtn.setImage(UIImage.init(named: icon!), for: .normal)
        itemBtn.setImage(UIImage.init(named: iconSelected!), for: .selected)
        
        // 事件
        itemBtn.addTarget(self, action: #selector(clickAction(btn:)), for: .touchUpInside)
        
        return itemBtn
    }
    
    @objc private func clickAction(btn: BTVerticalButton) -> Void {
        if btn.tag != self.selectedIndex {
            self.itemBtns[selectedIndex].isSelected = false
            self.itemBtns[btn.tag].isSelected = true
            self.delegate?.btbSubItemSelected(index: btn.tag)
        }
        self.selectedIndex = btn.tag
    }
    
    @objc private func centerTapAction() -> Void {
        self.delegate?.btbSubCenterClick()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.clipsToBounds || self.isHidden || self.alpha == 0 {
            return nil
        }
        
        var result: UIView! = super.hitTest(point, with: event)
        // 如果事件发生在tabbar里面，则直接返回
        if let _ = result {
            return result
        }
        
        // 遍历子视图
        for subview in self.subviews {
            // 将point转换为子视图的坐标
            let subPoint: CGPoint = subview.convert(point, from: self)
            result = subview.hitTest(subPoint, with: event)
            
            // 如果事件发生在subview里，则返回
            if let _ = result {
                return result
            }
        }
        
        return nil
    }
    
}
