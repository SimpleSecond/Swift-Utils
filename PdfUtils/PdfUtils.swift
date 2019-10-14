//
//  PdfUtils.swift
//  SwiftUI-01
//
//  Created by wdy on 2019/10/9.
//  Copyright © 2019 wdy. All rights reserved.
//

import UIKit

/**
 工具类：创建PDF文件
 */
class PdfUtils: NSObject {
    
    private let PageWidth  = 612    // 文档默认宽度
    private let PageHeight = 792    // 文档默认高度
    private let PaddingUpDown = 50     // 文档上下边距
    private let PaddingLeftRight = 50  // 文档左右边距
    
    // 可绘制的区域的宽度、高度、宽高比
    private var PageContentWidth: Int {
        get {
            return PageWidth - PaddingLeftRight * 2
        }
    }
    private var PageContentHeight: Int {
        get {
            return PageHeight - PaddingUpDown * 2
        }
    }
    private var PageContentRatio: Double {
        get {
            return Double.init(PageContentWidth) / Double.init(PageContentHeight)
        }
    }
    
    
    private override init() {
        
    }
    
    public class var shared: PdfUtils {
        get {
            struct SingletonWrapper {
                static let singleton = PdfUtils.init()
            }
            return SingletonWrapper.singleton
        }
    }
    
    // 第一种、创建一个临时的、空的PDF文档，并返回文档路径
    func createTempEmptyPDF() -> String {
        let tempPath = NSTemporaryDirectory()
        let tempPdfPath = tempPath + "temp.pdf"
        // URL
        let pdfUrl = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, tempPdfPath as CFString, .cfurlposixPathStyle, false)
        // 创建PDF
        let pdfCtx = CGContext.init(pdfUrl!, mediaBox: nil, nil)
        pdfCtx?.closePDF()
        
        return tempPdfPath
    }
    
    // 第二种、创建一个临时的、空的、多页的PDF文档
    func createTempEmptyPDF(pages: Int) -> String {
        let tempPath = NSTemporaryDirectory()
        let tempPdfPath = tempPath + "temp.pdf"
        // URL
        let pdfUrl = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, tempPdfPath as CFString, .cfurlposixPathStyle, false)
        // 创建PDF
        let pdfCtx = CGContext.init(pdfUrl!, mediaBox: nil, nil)
        
        for _ in 0..<pages {
            // 开始页面
            pdfCtx?.beginPDFPage(nil)
            // 这里对该页面进行绘制操作
            // ...
            // 结束页面
            pdfCtx?.endPDFPage()
            pdfCtx?.flush()
        }
        pdfCtx?.closePDF()
        
        return tempPdfPath
    }
    
    
    // 第三种、添加图片，一张图片对应一页
    func createPDF(pdfPath: String, images: [UIImage]) -> Void {
        let pdfUrl = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, pdfPath as CFString, .cfurlposixPathStyle, false)
        
        // 页面大小，默认为612x792
        let pdfCtx = CGContext.init(pdfUrl!, mediaBox: nil, nil)
        
        images.forEach { (img) in
            let drawRect = calculateDrawRect(image: img)
            
            // 开始页面
            pdfCtx?.beginPDFPage(nil)
            //pdfCtx?.beginPage(mediaBox: nil)
            // 这里对该页面进行绘制操作
            pdfCtx?.draw(img.cgImage!, in: drawRect)
            // 结束页面
            pdfCtx?.endPDFPage()
            pdfCtx?.flush()
        }
        
        pdfCtx?.closePDF()
    }
    
    // 计算需要绘制的区域
    private func calculateDrawRect(image: UIImage) -> CGRect {
        let imgWidth = image.cgImage?.width
        let imgHeight = image.cgImage?.height
        
        let originRatio = Double.init(imgWidth!) / Double.init(imgHeight!)
        
        var width = 0
        var height = 0
        
        if originRatio > PageContentRatio {
            width = PageContentWidth
            height = Int.init(Double.init(width) / originRatio)
        } else {
            height = PageContentHeight
            width = Int.init(Double.init(height) * originRatio)
        }
        
        let startX = PaddingLeftRight
        let startY = PageHeight - PaddingUpDown - height
        
        return CGRect.init(x: startX, y: startY, width: width, height: height)
    }
    
    
    // 1. 获取临时文件夹
    
    // 2. 在临时文件中创建一个pdf文档
    
    // 文件页面信息配置
    
    // 3. 设置pdf纸张大小
    
    // 4. 设置内边距(左、上、右、下，空白边距)大小
    
    // 5. 设置页头信息
    
    // 6. 设置页尾信息
    
    // 7. 设置内容信息
    
    //
}

